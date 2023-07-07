import 'package:testainers/src/testainers_base.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
class TestainersRedis extends Testainers {
  int? _port;

  ///
  ///
  ///
  TestainersRedis({
    int? port,
    super.config,
    super.name,
    super.image = 'redis',
    super.tag = '7-alpine',
    super.ports = const <int, int>{},
    super.env = const <String, String>{},
    super.detached = true,
    super.remove = true,
    super.healthCmd,
    super.healthInterval,
    super.healthRetries,
    super.healthTimeout,
    super.healthStartPeriod,
    super.noHealthcheck,
    super.stopTime,
  }) : _port = port;

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
    return <int, int>{...ports, _port!: 6379};
  }
}
