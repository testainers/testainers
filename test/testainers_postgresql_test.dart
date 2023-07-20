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
    test('create a table and insert a row', () async {
      await connection.execute(
        'CREATE TABLE test (id SERIAL PRIMARY KEY, name VARCHAR(99) NOT NULL);',
      );

      final PostgreSQLResult result = await connection.query(
        "INSERT INTO test (name) VALUES ('test') RETURNING id, name",
      );

      expect(result.affectedRowCount, 1);

      expect(result, <dynamic>[
        <dynamic>[1, 'test']
      ]);
    });

    test('delete the inserted row and drop the created table', () async {
      final PostgreSQLResult result = await connection.query(
        'DELETE FROM test WHERE id = 1',
      );

      expect(result.affectedRowCount, 1);

      await connection.execute('DROP TABLE test');
    });

    ///
    tearDownAll(() async {
      await connection.close();
      await container.stop();
    });
  });
}
