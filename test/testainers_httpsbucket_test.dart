import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:testainers/testainers.dart';

import '../helpers/http_service.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test Httpbucket', () {
    final TestainersHttpbucket container = TestainersHttpbucket();
    final HttpService httpService = HttpService();

    ///
    setUpAll(() async {
      await container.start();
    });

    ///
    test('Http Test', () async {
      final Response response = await get(
        Uri.parse('http://localhost:${container.httpPort}/methods'),
      );

      expect(response.statusCode, 200);
      expect(response.headers, isNotEmpty);
      expect(response.body, isNotEmpty);
    });

    ///
    test('Https Test', () async {
      final HttpClientResponse response = await httpService
          .get(Uri.parse('https://localhost:${container.httpsPort}/methods'));

      expect(response.statusCode, 200);
      expect(response.contentLength, greaterThan(0));
    });

    ///
    tearDownAll(() {
      httpService.close();
      container.stop();
    });
  });
}
