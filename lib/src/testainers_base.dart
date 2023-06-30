import 'dart:io';

import 'package:testainers/src/testainers_config.dart';
import 'package:testainers/src/testainers_exception.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
abstract class Testainers {
  final TestainersConfig config;
  final String name;
  final String image;
  final String tag;
  final Map<int, int> ports;
  final Map<String, String> env;
  final bool detached;
  final bool remove;
  String? id;

  ///
  ///
  ///
  Testainers({
    required this.image,
    required this.tag,
    required this.ports,
    required this.env,
    required this.detached,
    required this.remove,
    this.config = const TestainersConfig(),
    String? name,
  }) : name = name ?? TestainersUtils.generateName();

  ///
  ///
  ///
  Future<Map<int, int>> portsFilter(Map<int, int> ports) async => ports;

  ///
  ///
  ///
  Future<Map<String, String>> envFilter(Map<String, String> env) async => env;

  ///
  ///
  ///
  Future<void> start({Duration? bootSleep}) async {
    ProcessResult result = await Process.run(config.runner, <String>[
      '--version',
    ]).timeout(config.timeout);

    if (result.exitCode != 0) {
      throw TestainersException(
        'Runner ${config.runner} not found.',
        reason: result.stderr,
      );
    }

    final Map<int, int> effectivePorts = await portsFilter(ports);

    final Map<String, String> effectiveEnv = await envFilter(env);

    final List<String> arguments = <String>[
      'run',
      if (detached) '-d',
      if (remove) '--rm',
      '--name',
      name,
    ];

    for (final MapEntry<int, int> entry in effectivePorts.entries) {
      arguments
        ..add('-p')
        ..add('${entry.key}:${entry.value}');
    }

    for (final MapEntry<String, String> entry in effectiveEnv.entries) {
      arguments
        ..add('-e')
        ..add('"${entry.key}=${entry.value}"');
    }

    arguments.add('$image:$tag');

    // print('${config.runner} ${arguments.join(' ')}');

    result =
        await Process.run(config.runner, arguments).timeout(config.timeout);

    if (result.exitCode != 0) {
      throw TestainersException(
        'Container $name with image $image:$tag not started.',
        reason: result.stderr,
      );
    }

    id = result.stdout.toString().trim();

    // TODO(edufolly): Use healthcheck to continue.
    // https://docs.docker.com/engine/reference/run/#healthcheck
    await Future<void>.delayed(bootSleep ?? config.bootSleep);
  }

  ///
  ///
  ///
  Future<void> stop() async {
    final ProcessResult result = await Process.run(config.runner, <String>[
      'stop',
      name,
    ]).timeout(config.timeout);

    if (result.exitCode != 0) {
      throw TestainersException(
        'Container $name with image $image:$tag not stopped.',
        reason: result.stderr,
      );
    }

    if (result.stdout.toString().trim() != name) {
      throw TestainersException(
        'Check if the container $name has stopped.',
        reason: result.stdout,
      );
    }
  }
}
