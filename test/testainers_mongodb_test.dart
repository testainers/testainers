import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  group('Test MongoDB', () {
    final TestainersMongodb container = TestainersMongodb();

    late final Db db;
    late final DbCollection collection;

    final Map<String, dynamic> map = <String, dynamic>{
      'login': 'jdoe',
      'name': 'John Doe',
      'email': 'john@doe.com',
    };

    setUpAll(() async {
      await container.start();

      db = await Db.create(
        'mongodb://'
        '${container.username}:'
        '${container.password}@'
        'localhost:${container.port}'
        '/testainers?authSource=admin',
      );

      await db.open();

      collection = db.collection('users');
    });

    test('Insert One', () async {
      final WriteResult writeResult = await collection.insertOne(map);
      expect(writeResult.hasWriteErrors, isFalse);
    });

    test('List All', () async {
      final List<Map<String, dynamic>> list =
          await collection.find(where.eq('login', 'jdoe')).toList();
      expect(list.length, 1);

      final Map<String, dynamic> map = list.first;
      expect(map['login'], 'jdoe');
      expect(map['name'], 'John Doe');
      expect(map['email'], 'john@doe.com');
    });

    tearDownAll(() async {
      await db.close();
      await container.stop();
    });
  });
}
