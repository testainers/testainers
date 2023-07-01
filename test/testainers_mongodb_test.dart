import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';
import 'package:testainers/src/testainers_http_bin.dart';
import 'package:testainers/src/testainers_mongodb.dart';

import '../helpers/http_service.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test MongoDB', () {
    final TestainersMongodb container = TestainersMongodb();
    final HttpService httpService = HttpService();
    late final Db db;
    late final DbCollection collection;
    const String host = 'localhost';
    final Map<String, dynamic> map = <String, dynamic>{
      'login': 'jdoe',
      'name': 'John Doe',
      'email': 'john@doe.com',
    };

    ///
    setUpAll(() async {
      await container.start();

      db = await Db.create(
        'mongodb://'
        '${container.username}:'
        '${container.password}@'
        '$host:${container.port}'
        '/testainers?authSource=admin',
      );

      await db.open();

      collection = db.collection('users');
    });

    ///
    test('Insert One Test', () async {
      final WriteResult writeResult = await collection.insertOne(map);
      expect(writeResult.hasWriteErrors, isFalse);
    });

    ///
    test('', () async {
      final List<Map<String, dynamic>> list =
          await collection.find(where.eq('login', 'jdoe')).toList();
      expect(list.length, 1);

      final Map<String, dynamic> map = list.first;
      expect(map['login'], 'jdoe');
      expect(map['name'], 'John Doe');
      expect(map['email'], 'john@doe.com');
    });

    ///
    tearDownAll(() async {
      await db.close();
      httpService.close();
      await container.stop();
    });
  });
}
