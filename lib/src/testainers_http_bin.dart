import 'package:testainers/src/testainers_base.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
class TestainersHttpBin extends Testainers {
  int? _httpPort;

  ///
  ///
  ///
  TestainersHttpBin({
    int? httpPort,
    super.config,
    super.name,
    super.image = 'kennethreitz/httpbin',
    super.tag = 'latest',
    super.ports,
    super.env,
    super.detached,
    super.remove,
    super.links,
    super.networks,
    super.healthCmd,
    super.healthInterval,
    super.healthRetries,
    super.healthTimeout,
    super.healthStartPeriod,
    super.noHealthcheck,
    super.stopTime,
  }) : _httpPort = httpPort;

  ///
  ///
  ///
  int get httpPort => _httpPort ?? -1;

  ///
  ///
  ///
  @override
  Future<Map<int, int>> portsFilter(Map<int, int> ports) async {
    _httpPort ??= await TestainersUtils.generatePort();
    return <int, int>{...ports, _httpPort!: 80};
  }
}
