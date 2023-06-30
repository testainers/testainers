///
///
///
class TestainersConfig {
  final bool debug;
  final Duration timeout;
  final String runner;
  final Duration bootSleep;
  final String defaultUsername;
  final String defaultPassword;

  ///
  ///
  ///
  const TestainersConfig({
    this.debug = false,
    this.timeout = const Duration(seconds: 60),
    this.runner = 'docker',
    this.bootSleep = const Duration(seconds: 10),
    this.defaultUsername = 'testainers',
    this.defaultPassword = 'testword',
  });
}
