import 'package:testainers/src/testainers_base.dart';
import 'package:testainers/src/testainers_network.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
class TestainersSshd extends Testainers {
  String? _username;
  String? _password;
  int? _port;

  ///
  ///
  ///
  TestainersSshd({
    String? username,
    String? password,
    int? port,
    super.config,
    super.name,
    super.image = 'testainers/sshd-container',
    super.tag = 'latest',
    super.ports = const <int, int>{},
    super.env = const <String, String>{},
    super.detached = true,
    super.remove = true,
    super.links = const <String>[],
    super.networks = const <TestainersNetwork>[],
    super.healthCmd = r'sshpass -p "$SSHD_PASSWORD" ssh '
        '-o StrictHostKeyChecking=no '
        '-o UserKnownHostsFile=/dev/null '
        '-o PubkeyAuthentication=no '
        r'"$SSHD_USER"@127.0.0.1 uptime',
    super.healthInterval = 5,
    super.healthRetries = 2,
    super.healthTimeout = 3,
    super.healthStartPeriod = 1,
    super.noHealthcheck,
    super.stopTime = 1,
  })  : _username = username,
        _password = password,
        _port = port;

  ///
  ///
  ///
  String get username => _username ?? '';

  ///
  ///
  ///
  String get password => _password ?? '';

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
    return <int, int>{...ports, _port!: 22};
  }

  ///
  ///
  ///
  @override
  Future<Map<String, String>> envFilter(Map<String, String> env) async {
    _username ??= config.defaultUsername;
    _password ??= config.defaultPassword;
    return <String, String>{
      ...env,
      'SSHD_USER': _username!,
      'SSHD_PASSWORD': _password!,
    };
  }
}
