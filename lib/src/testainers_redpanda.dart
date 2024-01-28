import 'package:testainers/src/testainers_base.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
class TestainersRedpanda extends Testainers {
  final String defaultLogLevel;
  int? _brokerPort;
  int? _pandaProxyPort;
  int? _schemaRegistryPort;
  int? _rpcPort;
  int? _adminPort;

  ///
  ///
  ///
  TestainersRedpanda({
    this.defaultLogLevel = 'warn',
    int? brokerPort,
    int? pandaProxyPort,
    int? schemaRegistryPort,
    int? rpcPort,
    int? adminPort,
    super.config,
    super.name,
    super.image = 'redpandadata/redpanda',
    super.tag = 'v23.3.4',
    super.ports,
    super.env,
    super.detached,
    super.remove,
    super.links,
    super.networks,
    super.healthCmd = "rpk cluster health | grep -E 'Healthy:.+true' || exit 1",
    super.healthInterval = 5,
    super.healthRetries = 2,
    super.healthTimeout = 3,
    super.healthStartPeriod = 1,
    super.noHealthcheck,
    super.stopTime,
    super.command = const <String>[
      'redpanda',
      'start',
      '--overprovisioned',
      '--smp',
      '1',
      '--mode',
      'dev-container',
    ],
  })  : _brokerPort = brokerPort,
        _pandaProxyPort = pandaProxyPort,
        _schemaRegistryPort = schemaRegistryPort,
        _rpcPort = rpcPort,
        _adminPort = adminPort;

  ///
  ///
  ///
  int get brokerPort => _brokerPort ?? -1;

  ///
  ///
  ///
  int get pandaProxyPort => _pandaProxyPort ?? -1;

  ///
  ///
  ///
  int get schemaRegistryPort => _schemaRegistryPort ?? -1;

  ///
  ///
  ///
  int get rpcPort => _rpcPort ?? -1;

  ///
  ///
  ///
  int get adminPort => _adminPort ?? -1;

  ///
  ///
  ///
  @override
  Future<Map<int, int>> portsFilter(Map<int, int> ports) async {
    _brokerPort ??= await TestainersUtils.generatePort();
    _pandaProxyPort ??= await TestainersUtils.generatePort();
    _schemaRegistryPort ??= await TestainersUtils.generatePort();
    _rpcPort ??= await TestainersUtils.generatePort();
    _adminPort ??= await TestainersUtils.generatePort();

    return <int, int>{
      ...ports,
      _brokerPort!: _brokerPort!,
      _pandaProxyPort!: 18082,
      _schemaRegistryPort!: 18081,
      _rpcPort!: 33145,
      _adminPort!: 9644,
    };
  }

  ///
  ///
  ///
  @override
  Future<List<String>> commandFilter(List<String> command) async {
    return <String>[
      ...command,
      '--default-log-level=$defaultLogLevel',
      '--kafka-addr',
      'internal://0.0.0.0:9092,external://0.0.0.0:$_brokerPort',
      '--advertise-kafka-addr',
      'internal://localhost:9092,external://localhost:$_brokerPort',
      '--pandaproxy-addr',
      'internal://0.0.0.0:8082,external://0.0.0.0:18082',
      '--advertise-pandaproxy-addr',
      'internal://localhost:8082,external://localhost:18082',
      '--schema-registry-addr',
      'internal://0.0.0.0:8081,external://0.0.0.0:18081',
      '--rpc-addr',
      'localhost:33145',
      '--advertise-rpc-addr',
      'localhost:33145',
    ];
  }
}
