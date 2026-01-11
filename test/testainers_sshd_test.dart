import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  group('Test sshd', () {
    final TestainersSshd container = TestainersSshd();

    late final SSHClient? client;
    late final SSHSession? session;

    setUpAll(() async {
      await container.start();
    });

    test('Connect', () async {
      final SSHSocket socket = await SSHSocket.connect(
        'localhost',
        container.port,
        timeout: const Duration(seconds: 10),
      );

      client = SSHClient(
        socket,
        username: container.username,
        onPasswordRequest: () => container.password,
      );

      expect(client != null, true, reason: 'SSH client is null;');

      await client?.authenticated;

      session = await client?.shell();

      expect(session != null, true, reason: 'SSH session is null.');
    });

    test('Running free', () async {
      final Uint8List list = await client!.run('free');
      expect(list.length, greaterThan(0));
    });

    test('Disconnect', () async {
      session?.close();
      client?.close();
    });

    tearDownAll(container.stop);
  });
}
