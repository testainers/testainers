import 'dart:io';

import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  group('TestainersCompose', () {
    late TestainersCompose compose;
    late String composeFilePath;

    setUpAll(() async {
      // Create a temporary compose file with a simple alpine service.
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'testainers_compose_',
      );

      composeFilePath = '${tempDir.path}/docker-compose.yml';

      await File(composeFilePath).writeAsString('''
services:
  worker:
    image: alpine:latest
    command: sleep 30
''');

      compose = TestainersCompose(
        composePath: composeFilePath,
        projectName: 'testainers-compose-test',
      );
    });

    test('starts and stops services', () async {
      await compose.up();

      // Verify the service is running via exec.
      final String output = await compose.serviceExec(
        'worker',
        <String>['echo', 'compose works'],
      );

      expect(output, 'compose works');

      await compose.down();
    });

    test('up with build flag does not fail', () async {
      await compose.up(build: true);
      await compose.down();
    });

    test('down with volumes flag does not fail', () async {
      await compose.up();
      await compose.down(volumes: true);
    });

    test('serviceExec throws when service is not running', () async {
      try {
        await compose.serviceExec(
          'worker',
          <String>['echo', 'hi'],
        );
        fail('Should throw an exception');
      } on Exception catch (e) {
        expect(e, isA<TestainersException>());
        expect(e.toString(), contains('Exec failed'));
      }
    });

    test('waitForHealth returns false when endpoint is unreachable', () async {
      final bool ready = await compose.waitForHealth(
        'http://localhost:59999/nonexistent',
        timeout: const Duration(seconds: 4),
        interval: const Duration(seconds: 1),
      );

      expect(ready, isFalse);
    });

    tearDownAll(() async {
      // Ensure cleanup even if a test fails.
      try {
        await compose.down(volumes: true);
      } on Exception {
        // Ignore — may already be down.
      }

      // Clean up temp compose file.
      final File file = File(composeFilePath);
      if (file.existsSync()) {
        file.parent.deleteSync(recursive: true);
      }
    });
  });
}
