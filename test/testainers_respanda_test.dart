import 'package:kafkabr/kafka.dart';
import 'package:test/test.dart';
import 'package:testainers/src/testainers_redpanda.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('Test Redpanda', () {
    final TestainersRedpanda container = TestainersRedpanda();

    final int start = DateTime.now().millisecondsSinceEpoch;

    late ContactPoint host;

    const String topicName = 'myTopic';
    const int partitionId = 0;

    ///
    setUpAll(() async {
      Logger.root.level = Level.ALL;
      await container.start();
      host = ContactPoint('localhost', container.brokerPort);
    });

    test('producer', () async {
      final KafkaSession session = KafkaSession(<ContactPoint>[host]);

      final Producer producer = Producer(session, 1, 1000);

      final ProduceResult result = await producer.produce(<ProduceEnvelope>[
        ProduceEnvelope(topicName, partitionId, <Message>[
          Message('myMessage'.codeUnits, key: 'myKey'.codeUnits),
          Message('myMessage2'.codeUnits, key: 'myKey2'.codeUnits),
          Message('myMessage3'.codeUnits, key: 'myKey3'.codeUnits),
        ]),
      ]);

      print(result.hasErrors);
      print(result.offsets);

      await session.close();
    });

    test('consumer', () async {
      final KafkaSession session = KafkaSession(<ContactPoint>[host]);

      final ConsumerGroup consumerGroup =
          ConsumerGroup(session, 'myConsumerGroup');

      var topics = {
        topicName: {0} // list of partitions to consume from.
      };

      // final Consumer consumer = Consumer(
      //   session,
      //   consumerGroup,
      //   <String, Set<int>>{
      //     topicName: <int>{partitionId},
      //   },
      //   100,
      //   1,
      // )..onOffsetOutOfRange = OffsetOutOfRangeBehavior.resetToLatest;

      var consumer = Consumer(session, consumerGroup, topics, 100, 1);

      print('AAA');

      await for (MessageEnvelope batch in consumer.consume(limit: 2)) {
        print('BBB');

        batch.ack();
      }

      await session.close();
    });

    ///
    tearDownAll(() async {
      await container.stop();
    });
  });
}
