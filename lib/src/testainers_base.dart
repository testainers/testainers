import 'package:testainers/src/testainers_config.dart';

///
///
///
class Testainers {
  static TestainersConfig? _config;

  ///
  ///
  ///
  Testainers._internal(TestainersConfig? config) {
    _config ??= config ?? TestainersConfig();
  }
}

///
///
///
abstract class BaseContainer {
  final String name;
  final String image;
  final String tag;
  final Map<int, int> ports;
  final Map<String, String> env;

  ///
  ///
  ///
  BaseContainer(
    this.name,
    this.image,
    this.tag, {
    this.ports = const <int, int>{},
    this.env = const <String, String>{},
  });
}
