import 'dart:io';
import 'dart:math';

///
///
///
class TestainersUtils {
  ///
  ///
  ///
  static Map<String, String> loadEnv({
    String envFile = '.env',
    bool mergeWithPlatform = true,
  }) {
    final Map<String, String> env = <String, String>{};

    final File file = File(envFile);

    if (file.existsSync()) {
      final List<String> lines = file.readAsLinesSync();

      for (int i = 0; i < lines.length; i++) {
        final String line = lines[i];

        if(line.trim().startsWith('#')) {
          continue;
        }

        final List<String> parts = line.split('=');

        if (parts.length < 2) {
          continue;
        }

        if (parts.first.isEmpty) {
          continue;
        }

        String value = parts.getRange(1, parts.length).join('=');

        if (value.isEmpty) {
          continue;
        }

        if (value.trim().startsWith('"')) {
          final StringBuffer buffer = StringBuffer(value);

          while (!buffer.toString().trim().endsWith('"')) {
            i++;

            if (i >= lines.length) {
              buffer.write('"');
              continue;
            }

            buffer
              ..write('\n')
              ..write(lines[i]);
          }

          value = buffer.toString().trim();

          value = value.substring(1, value.length - 1).replaceAll(r'\n', '\n');
        } else {
          value = value.trim();
        }

        env[parts.first.trim()] = value;
      }
    }

    if (mergeWithPlatform) {
      env.addAll(Platform.environment);
    }

    return env;
  }

  ///
  ///
  ///
  static Future<int> generatePort({InternetAddress? address}) async {
    final RawServerSocket socket =
        await RawServerSocket.bind(address ?? InternetAddress.loopbackIPv4, 0);
    final int port = socket.port;
    await socket.close();
    return port;
  }

  ///
  ///
  ///
  static String generateName() {
    final List<String> animalList = <String>[
      'dog',
      'cat',
      'lion',
      'tiger',
      'elephant',
      'giraffe',
      'zebra',
      'cheetah',
      'gorilla',
      'chimpanzee',
      'orangutan',
      'bear',
      'panda',
      'koala',
      'kangaroo',
      'platypus',
      'dolphin',
      'whale',
      'shark',
      'octopus',
      'penguin',
      'eagle',
      'owl',
      'falcon',
      'peacock',
      'parrot',
      'flamingo',
      'toucan',
      'crocodile',
      'alligator',
      'turtle',
      'snake',
      'lizard',
      'frog',
      'salamander',
      'butterfly',
      'bee',
      'ant',
      'spider',
      'scorpion',
      'lobster',
      'crab',
      'fish',
      'seahorse',
      'jellyfish',
      'starfish',
      'horse',
      'cow',
      'sheep',
      'pig'
    ];

    final List<String> adjectiveList = <String>[
      'fierce',
      'majestic',
      'graceful',
      'playful',
      'agile',
      'cunning',
      'beautiful',
      'strong',
      'colorful',
      'adorable',
      'ferocious',
      'swift',
      'intelligent',
      'curious',
      'sly',
      'energetic',
      'camouflaged',
      'magnificent',
      'wild',
      'endangered',
      'nocturnal',
      'sociable',
      'powerful',
      'elusive',
      'vocal',
      'hardy',
      'slithery',
      'scaly',
      'lively',
      'gentle',
      'charming',
      'acrobatic',
      'busy',
      'gracious',
      'resourceful',
      'wise',
      'camouflaged',
      'playful',
      'silent',
      'prickly',
      'swift',
      'social',
      'busy',
      'ferocious',
      'sensitive',
      'majestic',
      'elegant',
      'vibrant',
      'inquisitive'
    ];

    return '${animalList[Random().nextInt(animalList.length)]}-'
        '${adjectiveList[Random().nextInt(adjectiveList.length)]}';
  }
}
