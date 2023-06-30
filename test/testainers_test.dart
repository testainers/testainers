import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:testainers/src/testainers_http_bin.dart';
import 'package:testainers/src/testainers_http_https_echo.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test HttpBin', () {
    final TestainersHttpBin container = TestainersHttpBin();

    ///
    setUpAll(() async {
      await container.start();
    });

    ///
    test('First Test', () async {
      final Response response =
          await get(Uri.parse('http://localhost:${container.httpPort}'));

      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    ///
    tearDownAll(container.stop);
  });

  ///
  ///
  ///
  group('Test HttpHttpsEcho', () {
    final TestainersHttpHttpsEcho container = TestainersHttpHttpsEcho();

    ///
    setUpAll(() async {
      await container.start();
    });

    ///
    test('Http Test', () async {
      final Response response =
          await get(Uri.parse('http://localhost:${container.httpPort}'));

      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    ///
    tearDownAll(container.stop);
  });
}
