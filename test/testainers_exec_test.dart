import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  group('Testainers exec', () {
    final Testainers container = Testainers(
      image: 'alpine',
      tag: 'latest',
      detached: true,
      remove: true,
      env: const <String, String>{},
      ports: const <int, int>{},
      command: const <String>['sleep', '30'],
    );

    setUpAll(() async {
      await container.start(bootSleep: const Duration(seconds: 2));
    });

    test('executes a simple echo command', () async {
      final String output = await container.exec(
        command: <String>['echo', 'hello testainers'],
      );

      expect(output, 'hello testainers');
    });

    test('executes a command with exit output', () async {
      final String output = await container.exec(
        command: <String>['cat', '/etc/hostname'],
      );

      expect(output, isNotEmpty);
    });

    test('throws when command fails', () async {
      try {
        await container.exec(
          command: <String>['cat', '/nonexistent/file'],
        );
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains('Exec failed'));
      }
    });

    test('throws when container not started', () async {
      final Testainers unstarted = Testainers(
        image: 'alpine',
        tag: 'latest',
        detached: true,
        remove: true,
        env: const <String, String>{},
        ports: const <int, int>{},
      );

      try {
        await unstarted.exec(command: <String>['echo', 'hi']);
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains('not started'));
      }
    });

    tearDownAll(container.stop);
  });
}
