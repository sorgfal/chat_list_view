import 'package:chat_list_view/chat/data/chat_entity.dart';
import 'package:chat_list_view/chat/data/chat_repository.dart';
import 'package:chat_list_view/chat/ui/chat_view.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatRepository chatRepository = ChatRepository();
  late final ChatController chatController = ChatController(
    context: context,
    onLoadMore: _onLoadMoreRequest,
  );

  Future<bool> _onLoadMoreRequest(ChatEntity lastEntity) async {
    final msgs =
        await chatRepository.getHistoryAfter(id: lastEntity.id, count: 30);
    chatController.onOldMessages(msgs);
    return msgs.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      chatRepository.messages().listen((event) {
        chatController.onNewMessage(event);
      });
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: chatController.jumpToStart,
      ),
      body: SafeArea(
          child: ChatView(
        chatController: chatController,
      )),
    );
  }
}
