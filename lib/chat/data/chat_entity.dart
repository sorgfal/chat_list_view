import 'dart:math';
import 'package:faker/faker.dart';

int _globalIndex = 0;
final startTime = DateTime.now();

sealed class ChatEntity {
  final int id;

  ChatEntity({required this.id});

  factory ChatEntity.random() {
    final r = Random();
    final f = Faker();

    final t = r.nextInt(7);

    final o = switch (t) {
      int when t <= 5 => ChatEntity$Message(
          fromMe: r.nextBool(),
          id: _globalIndex,
          message: faker.lorem.words(r.nextInt(50) + 10).join(' ')),
      6 => ChatEntity$DateBadge(
          id: _globalIndex, date: startTime.add(Duration(days: _globalIndex))),
      _ => ChatEntity$Message(
          fromMe: r.nextBool(),
          id: _globalIndex,
          message: faker.lorem.words(r.nextInt(50) + 10).join(' '))
    };
    _globalIndex++;
    return o;
  }

  factory ChatEntity.randomWithId(int id) {
    final r = Random();
    final f = Faker();

    final t = r.nextInt(7);

    final o = switch (t) {
      int when t <= 5 => ChatEntity$Message(
          fromMe: r.nextBool(),
          id: id,
          message: faker.lorem.words(r.nextInt(50) + 10).join(' ')),
      6 =>
        ChatEntity$DateBadge(id: id, date: startTime.add(Duration(days: id))),
      _ => ChatEntity$Message(
          fromMe: r.nextBool(),
          id: id,
          message: faker.lorem.words(r.nextInt(50) + 10).join(' '))
    };

    return o;
  }
}

class ChatEntity$Message extends ChatEntity {
  final String message;
  final bool fromMe;

  ChatEntity$Message(
      {required super.id, required this.message, required this.fromMe});
}

class ChatEntity$DateBadge extends ChatEntity {
  final DateTime date;

  ChatEntity$DateBadge({required this.date, required super.id});
}
