import 'dart:io';
import 'dart:math';

class TestainersUtils {
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

        if (line.trim().startsWith('#')) {
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

  static Future<int> generatePort({InternetAddress? address}) async {
    final RawServerSocket socket =
        await RawServerSocket.bind(address ?? InternetAddress.loopbackIPv4, 0);
    final int port = socket.port;
    await socket.close();
    return port;
  }

  static String generateName() {
    final List<String> animalList = <String>[
      'alligator',
      'alpaca',
      'ant',
      'armadillo',
      'badger',
      'bat',
      'bear',
      'beaver',
      'bee',
      'buffalo',
      'butterfly',
      'camel',
      'capybara',
      'caribou',
      'cat',
      'cheetah',
      'chimpanzee',
      'chinchilla',
      'chipmunk',
      'cobra',
      'cow',
      'coyote',
      'crab',
      'crocodile',
      'deer',
      'dog',
      'dolphin',
      'donkey',
      'dragonfly',
      'duck',
      'eagle',
      'elephant',
      'emu',
      'falcon',
      'ferret',
      'fish',
      'flamingo',
      'fox',
      'frog',
      'gazelle',
      'gecko',
      'giraffe',
      'goat',
      'goldfish',
      'gorilla',
      'hamster',
      'hedgehog',
      'hippopotamus',
      'hornet',
      'horse',
      'iguana',
      'jackal',
      'jaguar',
      'jellyfish',
      'kangaroo',
      'kitten',
      'koala',
      'lamb',
      'lemur',
      'leopard',
      'lion',
      'lizard',
      'llama',
      'lobster',
      'lynx',
      'macaw',
      'marmot',
      'meerkat',
      'mink',
      'mongoose',
      'moose',
      'mosquito',
      'mouse',
      'octopus',
      'opossum',
      'orangutan',
      'otter',
      'owl',
      'ox',
      'panda',
      'pangolin',
      'panther',
      'parrot',
      'peacock',
      'pelican',
      'penguin',
      'pig',
      'platypus',
      'puma',
      'quokka',
      'raccoon',
      'rat',
      'reindeer',
      'rhinoceros',
      'salamander',
      'scorpion',
      'seahorse',
      'seal',
      'shark',
      'sheep',
      'skunk',
      'sloth',
      'snail',
      'snake',
      'spider',
      'squirrel',
      'starfish',
      'swan',
      'tapir',
      'termite',
      'tiger',
      'tortoise',
      'toucan',
      'turtle',
      'vulture',
      'walrus',
      'weasel',
      'whale',
      'wolf',
      'wombat',
      'yak',
      'zebra',
    ];

    final List<String> adjectiveList = <String>[
      'acrobatic',
      'adorable',
      'agile',
      'beautiful',
      'busy',
      'busy',
      'camouflaged',
      'camouflaged',
      'charming',
      'colorful',
      'cunning',
      'curious',
      'elegant',
      'elusive',
      'endangered',
      'energetic',
      'ferocious',
      'ferocious',
      'fierce',
      'gentle',
      'graceful',
      'gracious',
      'hardy',
      'inquisitive',
      'intelligent',
      'lively',
      'magnificent',
      'majestic',
      'majestic',
      'nocturnal',
      'playful',
      'playful',
      'powerful',
      'prickly',
      'resourceful',
      'scaly',
      'sensitive',
      'silent',
      'slithery',
      'sly',
      'sociable',
      'social',
      'strong',
      'swift',
      'swift',
      'vibrant',
      'vocal',
      'wild',
      'wise',
      'adaptable',
      'alert',
      'ambitious',
      'amusing',
      'brave',
      'bright',
      'calm',
      'careful',
      'clever',
      'confident',
      'cooperative',
      'courageous',
      'creative',
      'daring',
      'determined',
      'diligent',
      'disciplined',
      'eager',
      'efficient',
      'faithful',
      'famous',
      'friendly',
      'funny',
      'generous',
      'gentle',
      'happy',
      'helpful',
      'honest',
      'humorous',
      'imaginative',
      'independent',
      'innovative',
      'intuitive',
      'kind',
      'knowledgeable',
      'likeable',
      'loving',
      'loyal',
      'modest',
      'neat',
      'nice',
      'obedient',
      'optimistic',
      'organized',
      'patient',
      'persistent',
      'pioneering',
      'polite',
      'popular',
      'practical',
      'quick',
      'quiet',
      'reliable',
      'reserved',
      'resourceful',
      'romantic',
      'self-confident',
      'self-disciplined',
      'sensible',
      'sensitive',
      'shy',
      'sincere',
      'smart',
      'sociable',
      'straightforward',
      'sympathetic',
      'thoughtful',
      'tidy',
      'tough',
      'trustworthy',
      'unassuming',
      'understanding',
      'versatile',
      'warmhearted',
      'willing',
      'witty',
    ];

    return '${animalList[Random().nextInt(animalList.length)]}-'
        '${adjectiveList[Random().nextInt(adjectiveList.length)]}';
  }
}
