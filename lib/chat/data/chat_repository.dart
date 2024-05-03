import 'dart:async';

import 'package:chat_list_view/chat/data/chat_entity.dart';

class ChatRepository {
  bool _messageStreamingEnabled = true;

  Stream<ChatEntity> messages() async* {
    while (_messageStreamingEnabled) {
      await Future.delayed(Duration(seconds: 2));
      yield ChatEntity.random();
    }
  }

  Future<List<ChatEntity>> getHistoryAfter(
      {required int id, required int count}) async {
    print('request $id');
    await Future.delayed(Duration(seconds: 1));
    if (id < -100) {
      return [];
    }
    return List.generate(
        count, (index) => ChatEntity.randomWithId(id - index - 1));
  }
}
