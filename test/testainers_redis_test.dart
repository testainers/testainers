import 'package:redis/redis.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test Redis', () {
    final TestainersRedis container = TestainersRedis();

    ///
    setUpAll(() async {
      await container.start();
    });

    ///
    test('First Test', () async {
      const String key = 'my_test_key';
      const String value = 'my_test_value';

      final RedisConnection redisConnection = RedisConnection();

      final Command command =
          await redisConnection.connect('localhost', container.port);

      final dynamic setCommand = await command.set(key, value);

      expect(setCommand, 'OK');

      final dynamic getCommand = await command.get(key);

      expect(getCommand, value);
    });

    ///
    tearDownAll(container.stop);
  });
}
