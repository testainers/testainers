///
///
///
class TestainersConfig {
  final Duration timeout;
  final String runner;
  final Duration bootSleep;

  ///
  ///
  ///
  const TestainersConfig({
    this.timeout = const Duration(seconds: 60),
    this.runner = 'docker',
    this.bootSleep = const Duration(seconds: 10),
  });
}
