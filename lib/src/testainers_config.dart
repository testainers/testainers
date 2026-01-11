import 'dart:io';

import 'package:testainers/src/testainers_exception.dart';

class TestainersConfig {
  final bool debug;
  final Duration timeout;
  final String runner;
  final Duration bootSleep;
  final String defaultUsername;
  final String defaultPassword;
  final String networkSuffix;

  const TestainersConfig({
    this.debug = false,
    this.timeout = const Duration(seconds: 60),
    this.runner = 'docker',
    this.bootSleep = const Duration(seconds: 10),
    this.defaultUsername = 'testainers',
    this.defaultPassword = 'testword',
    this.networkSuffix = '-net',
  });

  Future<String> runnerVersion() async {
    final ProcessResult result = await Process.run(runner, <String>[
      '--version',
    ]).timeout(timeout);

    if (result.exitCode != 0) {
      throw TestainersException(
        'Runner $runner not found.',
        reason: result.stderr,
      );
    }

    return result.stdout.toString().trim();
  }

  Future<ProcessResult> _exec({
    required List<String> arguments,
    required String exceptionExec,
  }) async {
    if (debug) print('$runner ${arguments.join(' ')}');

    final ProcessResult result = await Process.run(
      runner,
      arguments,
    ).timeout(timeout);

    if (result.exitCode != 0) {
      throw TestainersException(exceptionExec, reason: result.stderr);
    }

    return result;
  }

  Future<String> exec({
    required List<String> arguments,
    required String exceptionExec,
  }) async {
    final ProcessResult result = await _exec(
      arguments: arguments,
      exceptionExec: exceptionExec,
    );

    return result.stdout.toString().trim();
  }

  Future<void> execAndCheck({
    required List<String> arguments,
    required String check,
    required String exceptionExec,
    required String exceptionCheck,
  }) async {
    final ProcessResult result = await _exec(
      arguments: arguments,
      exceptionExec: exceptionExec,
    );

    if (result.stdout.toString().trim() != check) {
      throw TestainersException(exceptionCheck, reason: result.stdout);
    }
  }
}
