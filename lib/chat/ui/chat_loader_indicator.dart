import 'package:flutter/material.dart';

enum ChatLoaderIndicatorStateType { idle, loading, empty }

class ChatLoaderIndicator extends StatelessWidget {
  final ChatLoaderIndicatorStateType type;
  const ChatLoaderIndicator({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ChatLoaderIndicatorStateType.empty => Container(
          height: 32,
          child: const Center(
            child: const Text('Все загружено'),
          ),
        ),
      ChatLoaderIndicatorStateType.loading => Container(
          height: 32,
          child: const Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ChatLoaderIndicatorStateType.idle => const SizedBox(
          height: 0,
          width: 0,
        ),
    };
  }
}
