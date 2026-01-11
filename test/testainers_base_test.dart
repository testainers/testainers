import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  group('Test Base', () {
    const int httpPort = 8080;

    final Testainers container = Testainers(
      image: 'caddy',
      tag: '2.10-alpine',
      detached: true,
      remove: true,
      env: const <String, String>{},
      ports: const <int, int>{httpPort: 80},
    );

    setUpAll(() async {
      await container.start();
    });

    test('First Test', () async {
      final Response response =
          await get(Uri.parse('http://localhost:$httpPort'));

      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    tearDownAll(container.stop);
  });

  group('Base Errors', () {
    test('Empty runner', () async {
      final Testainers container = Testainers(
        config: const TestainersConfig(runner: ''),
        image: '',
        tag: '',
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains('Runner not defined.'));
      }
    });

    test('Invalid runner', () async {
      final Testainers container = Testainers(
        config: const TestainersConfig(runner: 'invalid-runner'),
        image: 'unknown',
        tag: 'unknown',
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<ProcessException>());
        expect(e.toString(), contains('No such file or directory'));
      }
    });

    test('Empty default username', () async {
      final Testainers container = Testainers(
        config: const TestainersConfig(defaultUsername: ''),
        image: 'unknown',
        tag: 'unknown',
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), 'Default username not defined.');
      }
    });

    test('Empty default password', () async {
      final Testainers container = Testainers(
        config: const TestainersConfig(defaultPassword: ''),
        image: 'unknown',
        tag: 'unknown',
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), 'Default password not defined.');
      }
    });

    test('Empty image', () async {
      const String image = '';
      const String tag = 'latest';

      final Testainers container = Testainers(
        image: image,
        tag: tag,
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains('Image not defined.'));
      }
    });

    test('Unknown image', () async {
      const String image = 'unknown';
      const String tag = 'latest';

      final Testainers container = Testainers(
        image: image,
        tag: tag,
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains('$image:$tag not started.'));
      }
    });

    test('Empty tag', () async {
      const String image = 'caddy';
      const String tag = '';

      final Testainers container = Testainers(
        image: image,
        tag: tag,
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains('Tag not defined.'));
      }
    });

    test('Unknown tag', () async {
      const String image = 'caddy';
      const String tag = 'unknown';

      final Testainers container = Testainers(
        image: image,
        tag: tag,
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await container.start();
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains("Unable to find image '$image:$tag'"));
      }
    });

    const Map<int, int> portsErrors = <int, int>{
      -1: 80,
      0: 80,
      80: -1,
      81: 0,
      65536: 80,
      8080: 65536,
    };

    for (final MapEntry<int, int> entry in portsErrors.entries) {
      test('Port error for ${entry.key}:${entry.value}', () async {
        const String image = 'caddy';
        const String tag = 'latest';

        final Testainers container = Testainers(
          image: image,
          tag: tag,
          detached: true,
          remove: true,
          env: const <String, String>{},
          ports: <int, int>{entry.key: entry.value},
        );

        try {
          await container.start();
          fail('Should throw an exception');
        } on Exception catch (e) {
          expect(e, isA<TestainersException>());
          expect(e.toString(), 'Invalid port ${entry.key}:${entry.value}.');
        }
      });
    }
  });
}
