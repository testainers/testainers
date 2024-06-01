import 'package:testainers/src/testainers_base.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
class TestainersMongodb extends Testainers {
  final String? _username;
  final String? _password;
  int? _port;

  ///
  ///
  ///
  TestainersMongodb({
    String? username,
    String? password,
    int? port,
    super.config,
    super.name,
    super.image = 'mongo',
    super.tag = '7.0.11',
    super.ports = const <int, int>{},
    super.env = const <String, String>{},
    super.detached = true,
    super.remove = true,
    super.links,
    super.networks,
    super.healthCmd = 'echo \'db.runCommand("ping").ok\' | '
        'mongosh localhost:27017/test --quiet',
    super.healthInterval = 5,
    super.healthRetries = 2,
    super.healthTimeout = 3,
    super.healthStartPeriod = 1,
    super.noHealthcheck,
    super.stopTime,
  })  : _username = username,
        _password = password,
        _port = port;

  ///
  ///
  ///
  String get username => _username ?? config.defaultUsername;

  ///
  ///
  ///
  String get password => _password ?? config.defaultPassword;

  ///
  ///
  ///
  int get port => _port ?? -1;

  ///
  ///
  ///
  @override
  Future<Map<int, int>> portsFilter(Map<int, int> ports) async {
    _port ??= await TestainersUtils.generatePort();
    return <int, int>{...ports, _port!: 27017};
  }

  ///
  ///
  ///
  @override
  Future<Map<String, String>> envFilter(Map<String, String> env) async =>
      <String, String>{
        ...env,
        'MONGO_INITDB_ROOT_USERNAME': username,
        'MONGO_INITDB_ROOT_PASSWORD': password,
      };
}
