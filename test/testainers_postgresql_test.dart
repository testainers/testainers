import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test Postgresql', () {
    final TestainersPostgresql container = TestainersPostgresql();

    late final PostgreSQLConnection connection;

    ///
    setUpAll(() async {
      await container.start();

      connection = PostgreSQLConnection(
        'localhost',
        container.port,
        container.database,
        username: container.username,
        password: container.password,
      );

      await connection.open();
    });

    ///
    test('should connect to the database', () async {
      final PostgreSQLResult result = await connection.query('SELECT 1');
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result[0][0], 1);
    });

    ///
    tearDownAll(() async {
      await connection.close();
      await container.stop();
    });
  });
}
