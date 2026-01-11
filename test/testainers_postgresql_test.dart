import 'package:postgres/postgres.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  group('Test Postgresql', () {
    final TestainersPostgresql container = TestainersPostgresql();

    late final Connection connection;

    setUpAll(() async {
      await container.start();

      connection = await Connection.open(
        settings: const ConnectionSettings(
          sslMode: SslMode.disable,
        ),
        Endpoint(
          host: 'localhost',
          port: container.port,
          database: container.database,
          username: container.username,
          password: container.password,
        ),
      );
    });

    test('should connect to the database', () async {
      final Result result = await connection.execute('SELECT 1');
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result[0][0], 1);
    });

    test('create a table and insert a row', () async {
      await connection.execute(
        'CREATE TABLE test (id SERIAL PRIMARY KEY, name VARCHAR(99) NOT NULL);',
      );

      final Result result = await connection.execute(
        "INSERT INTO test (name) VALUES ('test') RETURNING id, name",
      );

      expect(result.affectedRows, 1);

      expect(
        result,
        <dynamic>[
          <dynamic>[1, 'test'],
        ],
      );
    });

    test('delete the inserted row and drop the created table', () async {
      final Result result = await connection.execute(
        Sql.named('DELETE FROM test WHERE id = @id'),
        parameters: <String, dynamic>{
          'id': 1,
        },
      );

      expect(result.affectedRows, 1);

      await connection.execute('DROP TABLE test');
    });

    tearDownAll(() async {
      await connection.close();
      await container.stop();
    });
  });
}
