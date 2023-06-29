///
///
///
class TestainersConfig {
  final int timeout;
  final String runner;
  final String host;

  ///
  ///
  ///
  const TestainersConfig({
    this.timeout = 120,
    this.runner = 'docker',
    this.host = 'localhost',
  });
}
