import 'package:testainers/src/testainers_base.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
class TestainersPostgresql extends Testainers {
  final String? _username;
  final String? _password;
  final String? _database;
  int? _port;

  ///
  ///
  ///
  TestainersPostgresql({
    String? username,
    String? password,
    String? database,
    int? port,
    super.config,
    super.name,
    super.image = 'postgres',
    super.tag = '13.3',
    super.ports,
    super.env,
    super.detached,
    super.remove,
    super.links,
    super.networks,
    super.healthCmd = 'pg_isready -U postgres',
    super.healthInterval = 5,
    super.healthRetries = 2,
    super.healthTimeout = 3,
    super.healthStartPeriod = 1,
    super.noHealthcheck,
    super.stopTime,
    super.command,
  })  : _username = username,
        _password = password,
        _database = database,
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
  String get database => _database ?? config.defaultUsername;

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
    return <int, int>{...ports, _port!: 5432};
  }

  ///
  ///
  ///
  @override
  Future<Map<String, String>> envFilter(Map<String, String> env) async =>
      <String, String>{
        ...env,
        'POSTGRES_USER': username,
        'POSTGRES_PASSWORD': password,
        'POSTGRES_DB': database,
      };
}
