import 'package:testainers/src/testainers_base.dart';
import 'package:testainers/src/testainers_utils.dart';

class TestainersHttpHttpsEcho extends Testainers {
  int? _httpPort;
  int? _httpsPort;

  TestainersHttpHttpsEcho({
    int? httpPort,
    int? httpsPort,
    super.config,
    super.name,
    super.image = 'mendhak/http-https-echo',
    super.tag = 'latest',
    super.ports = const <int, int>{},
    super.env = const <String, String>{},
    super.detached = true,
    super.remove = true,
    super.links,
    super.networks,
    super.healthCmd,
    super.healthInterval,
    super.healthRetries,
    super.healthTimeout,
    super.healthStartPeriod,
    super.noHealthcheck,
    super.stopTime,
  })  : _httpPort = httpPort,
        _httpsPort = httpsPort;

  int get httpPort => _httpPort ?? -1;

  int get httpsPort => _httpsPort ?? -1;

  @override
  Future<Map<int, int>> portsFilter(Map<int, int> ports) async {
    _httpPort ??= await TestainersUtils.generatePort();
    _httpsPort ??= await TestainersUtils.generatePort();

    return <int, int>{
      ...ports,
      _httpPort!: 8080,
      _httpsPort!: 8443,
    };
  }
}
