import 'dart:convert';
import 'dart:io';

///
///
///
void main() {
  final Map<String, String> curt = <String, String>{
    'name': 'curt',
    'rootUri': '../',
    'packageUri': 'lib/',
    'languageVersion': '3.0',
  };

  final Map<String, dynamic> package = <String, dynamic>{
    'configVersion': 2,
    'packages': <Map<String, String>>[curt],
    'generated': DateTime.now().toIso8601String(),
    'generator': 'pub',
    'generatorVersion': '3.0.0',
  };

  File('coverage/package.json')
    ..createSync(recursive: true)
    ..writeAsStringSync(json.encode(package));
}
