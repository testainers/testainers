import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

void main() {
  group('Test HttpBin', () {
    final TestainersHttpBin container = TestainersHttpBin();

    setUpAll(() async {
      await container.start();
    });

    test('First Test', () async {
      final Response response =
          await get(Uri.parse('http://localhost:${container.httpPort}'));

      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    tearDownAll(container.stop);
  });
}
