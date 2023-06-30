import 'dart:io';

import 'package:test/test.dart';
import 'package:testainers/src/testainers_http_bin.dart';
import 'package:testainers/src/testainers_http_https_echo.dart';

import '../helpers/http_service.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test HttpBin', () {
    final TestainersHttpBin container = TestainersHttpBin();
    final HttpService httpService = HttpService();

    ///
    setUpAll(() async {
      await container.start();
    });

    ///
    test('First Test', () async {
      final HttpClientResponse response = await httpService
          .get(Uri.parse('http://localhost:${container.httpPort}'));

      expect(response.statusCode, 200);
      expect(response.headers.value('date'), isNotEmpty);
      expect(response.contentLength, greaterThan(0));
    });

    ///
    tearDownAll(() {
      httpService.close();
      container.stop();
    });
  });

  ///
  ///
  ///
  group('Test HttpHttpsEcho', () {
    final TestainersHttpHttpsEcho container = TestainersHttpHttpsEcho();
    final HttpService httpService = HttpService();

    ///
    setUpAll(() async {
      await container.start();
    });

    ///
    test('Http Test', () async {
      final HttpClientResponse response = await httpService
          .get(Uri.parse('http://localhost:${container.httpPort}'));

      expect(response.statusCode, 200);
      expect(response.headers.value('date'), isNotEmpty);
      expect(response.contentLength, greaterThan(0));
    });

    ///
    test('Https Test', () async {
      final HttpClientResponse response = await httpService
          .get(Uri.parse('https://localhost:${container.httpsPort}'));

      expect(response.statusCode, 200);
      expect(response.headers.value('date'), isNotEmpty);
      expect(response.contentLength, greaterThan(0));
    });


    ///
    tearDownAll(() {
      httpService.close();
      container.stop();
    });
  });
}
