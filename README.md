<h1>
<img src="helpers/testainers-100.png" alt="Testainers" title="Testainers">
Testainers
</h1>

[![Build With Love](https://img.shields.io/badge/%20built%20with-%20%E2%9D%A4-ff69b4.svg)](https://github.com/edufolly/testainers/stargazers)
[![Version](https://img.shields.io/pub/v/testainers?color=orange)](https://pub.dev/packages/testainers)
[![Licence](https://img.shields.io/github/license/edufolly/testainers?color=blue)](https://github.com/edufolly/testainers/blob/main/LICENSE)
[![Build](https://img.shields.io/github/actions/workflow/status/edufolly/testainers/main.yml?branch=main)](https://github.com/edufolly/testainers/releases/latest)
[![Coverage Report](https://img.shields.io/badge/coverage-report-C08EA1)](https://edufolly.github.io/testainers/coverage/)

Testainers is a powerful Dart plugin designed to streamline the management of
containers for testing purposes. With Testainers, developers can effortlessly
create, configure, and manage isolated test environments within containers,
ensuring consistent and reliable testing processes.

This plugin provides a user-friendly interface to handle container
orchestration, allowing developers to quickly spin up and tear down test
containers, define dependencies, and execute tests seamlessly.

Testainers empowers developers to achieve efficient and reproducible testing
workflows, enabling them to focus on writing high-quality code while ensuring
the reliability and integrity of their software through comprehensive
containerized testing.

## Funding

Your contribution will help drive the development of quality tools for the
Flutter and Dart developer community. Any amount will be appreciated.
Thank you for your continued support!

[![BuyMeACoffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/edufolly)

## PIX

Sua contribuição ajudará a impulsionar o desenvolvimento de ferramentas de
qualidade para a comunidade de desenvolvedores Flutter e Dart. Qualquer quantia
será apreciada.
Obrigado pelo seu apoio contínuo!

[![PIX](helpers/pix.png)](https://nubank.com.br/pagar/2bt2q/RBr4Szfuwr)

## Usage

```dart
import 'dart:io';

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
  group('Test Httpbucket', () {
    final TestainersHttpbucket container = TestainersHttpbucket();

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
    tearDownAll(container.stop);
  });
}
```

## Available Containers

Open an issue to request a new container.

- [X] httpbucket - https://hub.docker.com/r/testainers/httpbucket - v0.0.6
- [X] redis - https://hub.docker.com/_/redis - v0.0.5
- [X] sshd - https://hub.docker.com/r/testainers/sshd-container - v0.0.4
- [x] MongoDB - https://hub.docker.com/_/mongo - v0.0.2
- [x] httpbin - https://hub.docker.com/r/kennethreitz/httpbin - v0.0.1
- [x] http-https-echo - https://hub.docker.com/r/mendhak/http-https-echo -
  v0.0.1
