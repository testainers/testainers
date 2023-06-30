// ignore_for_file: avoid_print

import 'dart:io';

import 'package:markdown/markdown.dart';

///
///
///
void main(List<String> args) {
  if (args.length != 2) {
    print('Invalid parameters.');
    exit(10);
  }

  final File mdFile = File(args.first);

  if (!mdFile.existsSync()) {
    print('Markdown file not exists.');
  }

  const String template = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>curt</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-aFq/bzH65dt+w6FI2ooMVUpc+21e0SRygnTpmBvdBgSdnuTN7QbdgL+OapgHtvPp"
          crossorigin="anonymous">
</head>
<body>
  <div class="col-lg-8 mx-auto p-4 py-md-5">
    <main>
{{body}}
    </main>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/js/bootstrap.bundle.min.js" 
          integrity="sha384-qKXV1j0HvMUeCBQ+QVp7JcfGl760yU08IQ+GpUo5hlbpg51QRiuqHAJz8+BrxE/N" 
          crossorigin="anonymous"></script>
</body>
</html>
''';

  File(args.last)
    ..createSync(recursive: true)
    ..writeAsStringSync(
      template.replaceAll(
        '{{body}}',
        markdownToHtml(
          mdFile.readAsStringSync(),
          extensionSet: ExtensionSet.gitHubWeb,
        ),
      ),
    );
}
