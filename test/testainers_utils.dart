import 'package:test/test.dart';
import 'package:testainers/src/testainers_utils.dart';

///
///
///
void main() {
  const Map<String, String> success = <String, String>{
    'TEST1': 'OK',
    'TEST_2': 'OK=OK',
    'TEST_3': r'OK\nOK',
    'TEST_4': 'OK',
    'TEST_5': 'OK',
    'TEST_6': 'OK',
    'QUOTED': '123',
    'QUOTED_2': '123\n123',
    'QUOTED_3': ' 123 123 ',
    'QUOTED_4': '123',
    'QUOTED_5': '123',
    'QUOTED_6': '123',
    'MULTILINE': '123\n123',
    'MULTILINE_2': '123\n#\n123',
    'UNCLOSED_FINAL': 'UNCLOSED\n\nFINAL',
  };

  ///
  group('loadEnv', () {
    test('Load file and merge with Platform.environment', () {
      final Map<String, String> env =
          TestainersUtils.loadEnv(envFile: 'test/test.env');

      for (final MapEntry<String, String> entry in success.entries) {
        expect(env[entry.key], entry.value);
      }

      expect(env.length, greaterThan(success.length));
    });

    test('Only load file', () {
      final Map<String, String> env = TestainersUtils.loadEnv(
        envFile: 'test/test.env',
        mergeWithPlatform: false,
      );

      expect(env, success);
    });

    test('Invalid file with Platform.environment', () {
      final Map<String, String> env =
          TestainersUtils.loadEnv(envFile: 'test/unknown.env');

      for (final String key in success.keys) {
        expect(env[key], isNull);
      }

      expect(env, isNotEmpty);
    });

    test('Invalid file without Platform.environment', () {
      final Map<String, String> env = TestainersUtils.loadEnv(
        envFile: 'test/unknown.env',
        mergeWithPlatform: false,
      );

      expect(env, isEmpty);
    });
  });

  ///
  group('generateName', () {
    test('returns a string with two words separated by a hyphen', () {
      final String name = TestainersUtils.generateName();
      expect(name, matches(RegExp(r'^\w+-\w+$')));
    });
  });
}
