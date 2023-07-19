import 'package:testainers/src/testainers_config.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
enum TestainersNetworkDriver {
  bridge,
  overlay;
}

///
///
///
class TestainersNetwork {
  final TestainersNetworkDriver driver;
  final bool attachable;
  final TestainersConfig config;
  final String name;
  String? id;

  ///
  ///
  ///
  TestainersNetwork({
    this.driver = TestainersNetworkDriver.bridge,
    this.attachable = true,
    this.config = const TestainersConfig(),
    String? name,
  }) : name = name ??
            '${TestainersUtils.generateName()}'
                '${config.networkSuffix}';

  ///
  ///
  ///
  Future<String> create() async {
    final List<String> arguments = <String>[
      'network',
      'create',
      '--driver',
      driver.name,
      if (attachable) '--attachable',
      name,
    ];

    id = await config.exec(
      arguments: arguments,
      exceptionExec: 'Network $name not created.',
    );

    return id!;
  }

  ///
  ///
  ///
  Future<void> remove({bool force = false}) async {
    final List<String> arguments = <String>[
      'network',
      'rm',
      if (force) '--force',
      name,
    ];

    await config.execAndCheck(
      arguments: arguments,
      check: name,
      exceptionExec: 'Network $name not removed.',
      exceptionCheck: 'Check if the network $name has stopped.',
    );
  }
}
