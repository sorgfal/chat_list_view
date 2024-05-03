import 'package:chat_list_view/chat/data/chat_entity.dart';

import 'package:chat_list_view/chat/ui/chat_bubble_render_object.dart';
import 'package:chat_list_view/chat/ui/chat_loader_indicator.dart';
import 'package:chat_list_view/chat/ui/utils/height_manager.dart';
import 'package:flutter/material.dart';

part 'chat_controller.dart';

class ChatView extends StatefulWidget {
  final ChatController chatController;
  const ChatView({super.key, required this.chatController});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _detectCurrentStartBubbleIndex() {
    final currentOffset =
        widget.chatController.scrollController.position.pixels;
    double calculatedIndex = 0;
    double calculatedHeight = 0;
    int lastId = 0;
    final bubbleIter = currentBubbles.iterator;
    while (calculatedHeight < currentOffset && bubbleIter.moveNext()) {
      lastId = bubbleIter.current.chatEntity.id;
      final height = heightManager[lastId];
      calculatedHeight += height ?? 0;
      calculatedIndex++;
    }

    print([calculatedHeight, calculatedIndex, lastId]);
  }

  List<ChatBubble> get currentBubbles => widget.chatController._currentBubbles;
  List<ChatEntity> get entities => widget.chatController._entities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            TextButton(
                onPressed: widget.chatController._addNewMessage,
                child: Text('Новое сообщение')),
            TextButton(
                onPressed: widget.chatController._add100NewMessage,
                child: Text('100 новых')),
            TextButton(
                onPressed: widget.chatController.jumpToStart,
                child: Text('В начало'))
          ],
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (notification) {
              switch (notification) {
                case ScrollStartNotification notification:
                  widget.chatController._onScrollStart();
                  break;
                case ScrollEndNotification notification:
                  widget.chatController._onScrollEnd();
                  break;
                case ScrollUpdateNotification notification:
                  if (notification.metrics.extentAfter == 0) {
                    widget.chatController._onOldMessageRequest();
                  }
                  break;
                default:
                  break;
              }

              return true;
            },
            child: ListenableBuilder(
              listenable: widget.chatController,
              builder: (context, child) => ListView.builder(
                padding: EdgeInsets.zero,
                controller: widget.chatController.scrollController,
                reverse: true,
                itemExtentBuilder: (index, dimensions) {
                  if (index < entities.length) {
                    return heightManager[entities[index].id] ?? 1000;
                  }
                  return 32;
                },
                itemCount: currentBubbles.length + 1,
                itemBuilder: (context, index) {
                  if (index == currentBubbles.length) {
                    return ChatLoaderIndicator(
                        type: widget.chatController.loaderState);
                  }

                  return currentBubbles[index];
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
