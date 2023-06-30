import 'dart:io';
import 'dart:math';

///
///
///
class TestainersUtils {
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
