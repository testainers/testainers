import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test Base', () {
    const int httpPort = 8080;

    final Testainers container = Testainers(
      image: 'caddy',
      tag: '2.6-alpine',
      detached: true,
      remove: true,
      env: const <String, String>{},
      ports: const <int, int>{8080: 80},
    );

    ///
    setUpAll(() async {
      await container.start();
    });

    ///
    test('First Test', () async {
      final Response response =
          await get(Uri.parse('http://localhost:$httpPort'));

      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    ///
    tearDownAll(container.stop);
  });
}
