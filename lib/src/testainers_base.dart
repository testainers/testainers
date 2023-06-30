import 'dart:convert';
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
  final String healthCmd;
  final int healthInterval;
  final int healthRetries;
  final int healthTimeout;
  final int healthStartPeriod;
  final bool noHealthcheck;
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
    this.healthCmd = '',
    this.healthInterval = 0,
    this.healthRetries = 0,
    this.healthTimeout = 0,
    this.healthStartPeriod = 0,
    this.noHealthcheck = false,
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
        ..add('${entry.key}=${entry.value}');
    }

    if (healthCmd.isNotEmpty) {
      arguments.add('--health-cmd=$healthCmd');

      if (healthInterval > 0) {
        arguments.add('--health-interval=${healthInterval}s');
      }

      if (healthRetries > 0) {
        arguments.add('--health-retries=$healthRetries');
      }

      if (healthTimeout > 0) {
        arguments.add('--health-timeout=${healthTimeout}s');
      }

      if (healthStartPeriod > 0) {
        arguments.add('--health-start-period=${healthStartPeriod}s');
      }
    }

    if (noHealthcheck) {
      arguments.add('--no-healthcheck');
    }

    arguments.add('$image:$tag');

    if (config.debug) {
      print('${config.runner} ${arguments.join(' ')}');
    }

    result = await Process.run(
      config.runner,
      arguments,
    ).timeout(config.timeout);

    if (result.exitCode != 0) {
      throw TestainersException(
        'Container $name with image $image:$tag not started.',
        reason: result.stderr,
      );
    }

    id = result.stdout.toString().trim();

    if (healthCmd.isEmpty || noHealthcheck) {
      await Future<void>.delayed(bootSleep ?? config.bootSleep);
    } else {
      late Map<dynamic, dynamic> inspectMap;

      String healthStatus = 'starting';

      while (healthStatus == 'starting') {
        await Future<void>.delayed(const Duration(seconds: 1));

        result = await Process.run(
          config.runner,
          <String>[
            'inspect',
            "--format='{{json .State.Health}}'",
            name,
          ],
        ).timeout(config.timeout);

        if (result.exitCode != 0) {
          throw TestainersException(
            'Container $name with image $image:$tag could not be inspected.',
            reason: result.stderr,
          );
        }

        final String inspectString = result.stdout.toString().trim();

        inspectMap =
            jsonDecode(inspectString.substring(1, inspectString.length - 1));

        if (config.debug) {
          print('Inspect: $inspectMap');
        }

        healthStatus = inspectMap['Status'];
      }

      if (healthStatus != 'healthy') {
        throw TestainersException(
          'Container $name with image $image:$tag is $healthStatus.',
          reason: inspectMap,
        );
      }
    }
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
