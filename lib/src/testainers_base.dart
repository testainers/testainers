import 'dart:convert';
import 'dart:io';

import 'package:testainers/src/testainers_config.dart';
import 'package:testainers/src/testainers_exception.dart';
import 'package:testainers/src/testainers_network.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
class Testainers {
  final String image;
  final String tag;
  final Map<int, int> ports;
  final Map<String, String> env;
  final bool detached;
  final bool remove;
  final List<String> links;
  final List<TestainersNetwork> networks;
  final String healthCmd;
  final int healthInterval;
  final int healthRetries;
  final int healthTimeout;
  final int healthStartPeriod;
  final bool noHealthcheck;
  final int stopTime;
  final TestainersConfig config;
  final String name;
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
    this.links = const <String>[],
    this.networks = const <TestainersNetwork>[],
    this.healthCmd = '',
    this.healthInterval = 0,
    this.healthRetries = 0,
    this.healthTimeout = 0,
    this.healthStartPeriod = 0,
    this.noHealthcheck = false,
    this.stopTime = 0,
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
  Future<List<String>> linksFilter(List<String> links) async => links;

  ///
  ///
  ///
  Future<List<TestainersNetwork>> networksFilter(
    List<TestainersNetwork> networks,
  ) async =>
      networks;

  ///
  ///
  ///
  Future<String> start({Duration? bootSleep}) async {
    if (config.runner.isEmpty) {
      throw TestainersException('Runner not defined.');
    }

    if (config.defaultUsername.isEmpty) {
      throw TestainersException('Default username not defined.');
    }

    if (config.defaultPassword.isEmpty) {
      throw TestainersException('Default password not defined.');
    }

    if (image.isEmpty) {
      throw TestainersException('Image not defined.');
    }

    if (tag.isEmpty) {
      throw TestainersException('Tag not defined.');
    }

    await config.runnerVersion();

    final List<String> arguments = <String>[
      'run',
      if (detached) '-d',
      if (remove) '--rm',
      '--name',
      name,
    ];

    final Map<int, int> effectivePorts = await portsFilter(ports);

    for (final MapEntry<int, int> entry in effectivePorts.entries) {
      /// Zero is a docker random port.
      if (entry.key <= 0 ||
          entry.key > 65535 ||
          entry.value <= 0 ||
          entry.value > 65535) {
        throw TestainersException(
          'Invalid port ${entry.key}:${entry.value}.',
        );
      }

      arguments
        ..add('-p')
        ..add('${entry.key}:${entry.value}');
    }

    final Map<String, String> effectiveEnv = await envFilter(env);

    for (final MapEntry<String, String> entry in effectiveEnv.entries) {
      arguments
        ..add('-e')
        ..add('${entry.key}=${entry.value}');
    }

    for (final String link in await linksFilter(links)) {
      if (link.isNotEmpty) {
        arguments
          ..add('--link')
          ..add(link);
      }
    }

    for (final TestainersNetwork network in await networksFilter(networks)) {
      arguments
        ..add('--network')
        ..add(network.name);
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

    id = await config.exec(
      arguments: arguments,
      exceptionExec: 'Container $name with image $image:$tag not started.',
    );

    if (healthCmd.isEmpty || noHealthcheck) {
      await Future<void>.delayed(bootSleep ?? config.bootSleep);
    } else {
      late Map<dynamic, dynamic> inspectMap;

      String healthStatus = 'starting';

      while (healthStatus == 'starting') {
        await Future<void>.delayed(const Duration(seconds: 1));

        final String inspectString = await config.exec(
          arguments: <String>[
            'inspect',
            "--format='{{json .State.Health}}'",
            name,
          ],
          exceptionExec: 'Container $name with image $image:$tag '
              'could not be inspected.',
        );

        inspectMap =
            jsonDecode(inspectString.substring(1, inspectString.length - 1));

        if (config.debug) {
          // ignore: avoid_print
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

    return id!;
  }

  ///
  ///
  ///
  Future<void> stop() async {
    final List<String> arguments = <String>[
      'stop',
      if (stopTime > 0) ...<String>['--time', '$stopTime'],
      name,
    ];

    final ProcessResult result = await Process.run(
      config.runner,
      arguments,
    ).timeout(config.timeout);

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
