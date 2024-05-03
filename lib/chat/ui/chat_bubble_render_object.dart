import 'package:chat_list_view/chat/data/chat_entity.dart';
import 'package:flutter/material.dart';

class ChatBubble extends LeafRenderObjectWidget {
  final ChatEntity chatEntity;
  const ChatBubble({super.key, required this.chatEntity});

  @override
  RenderBox createRenderObject(BuildContext context) {
    return switch (chatEntity) {
      ChatEntity$Message message => ChatMessageBubbleRenderObject(message),
      ChatEntity$DateBadge date => ChatDateBubbleRenderObject(date)
    };
  }
}

class ChatMessageBubbleRenderObject extends RenderBox {
  final ChatEntity$Message badge;
  ChatMessageBubbleRenderObject(this.badge);

  Paint myMessagePainter = Paint()
    ..color = Colors.blueGrey.shade100
    ..style = PaintingStyle.fill;
  Paint otherMessagePainter = Paint()
    ..color = Colors.yellow.shade100
    ..style = PaintingStyle.fill;

  @override
  void performLayout() {
    final labelSize = _layoutText();

    size = constraints
        .constrain(Size(labelSize.width + 16, labelSize.height + 16 + 8));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Offset baseOffset = const Offset(8, 0);
    if (badge.fromMe) {
      baseOffset = const Offset(48, 0);
    }

    context.canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(baseOffset.dx, 0, size.width - 56, size.height - 8),
            const Radius.circular(8)),
        badge.fromMe ? myMessagePainter : otherMessagePainter);

    textPainter.paint(
      context.canvas,
      Offset(baseOffset.dx + 8, 8),
    );
  }

  late TextPainter textPainter;
  Size _layoutText() {
    textPainter.layout(maxWidth: constraints.maxWidth - 56 - 12);
    final labelSize = textPainter.size;
    return labelSize;
  }
}

class ChatDateBubbleRenderObject extends RenderBox {
  ChatEntity$DateBadge badge;
  ChatDateBubbleRenderObject(this.badge) {
    textPainter = TextPainter(
        text: TextSpan(
            text: badge.date.toIso8601String(),
            style: const TextStyle(color: Colors.black)))
      ..textDirection = TextDirection.ltr;
  }
  Paint bgPainter = Paint()
    ..color = Colors.blueGrey[200]!
    ..strokeWidth = 3
    ..style = PaintingStyle.fill;

  @override
  void performLayout() {
    final textSize = _layoutText();
    size = constraints.constrain(Size.fromHeight(textSize.height + 24));
  }

  late TextPainter textPainter;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(
        Rect.fromLTWH(0, 0, constraints.maxWidth, size.height - 8), bgPainter);
    final textSize = _layoutText();
    final textOffset = size
        .center(Offset.zero)
        .translate(-textSize.width / 2, (-textSize.height - 8) / 2);
    textPainter.paint(context.canvas, textOffset);
  }

  Size _layoutText() {
    textPainter.layout(maxWidth: constraints.maxWidth);
    final labelSize = textPainter.size;
    return labelSize;
  }
}
