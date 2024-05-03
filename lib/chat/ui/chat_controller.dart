part of 'chat_view.dart';

/// Принимает в себя 1 сообщение из конца и должен вернуть Future<bool> в котором говорится - а есть ли еще элементы и мы становимся в состояние все загружено
typedef HistoryLoaderRequester = Future<bool> Function(ChatEntity lastEntity);

class ChatController extends ChangeNotifier {
  final BuildContext context;
  final HistoryLoaderRequester onLoadMore;
  late final ScrollController scrollController = ScrollController();
  ChatLoaderIndicatorStateType loaderState = ChatLoaderIndicatorStateType.idle;

  List<ChatBubble> _currentBubbles = [];
  List<ChatEntity> _newMessagesBuffer = [];
  List<ChatEntity> _entities = [];
  bool inScroll = false;

  ChatController({required this.context, required this.onLoadMore});

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _addNewMessage() {
    final r = ChatEntity.random();
    onNewMessage(r);
  }

  void _cleanBuffer() {
    while (_newMessagesBuffer.isNotEmpty) {
      onNewMessage(_newMessagesBuffer.removeAt(0));
    }
  }

  _onScrollEnd() {
    inScroll = false;
    _cleanBuffer();
  }

  _onScrollStart() {
    inScroll = true;
  }

  void _onBufferizeNewMessages(ChatEntity entity) {
    _newMessagesBuffer.add(entity);
  }

  Size? _screenSize;
  Size get screenSize => _screenSize ??= MediaQuery.sizeOf(context);

  void _onNewMessageAddition(ChatEntity entity) {
    final w = ChatBubble(
      key: ValueKey(entity.id),
      chatEntity: entity,
    );
    final ro = w.createRenderObject(context);
    ro.layout(BoxConstraints(maxWidth: MediaQuery.of(context).size.width));

    double itemHeight = ro.size.height;

    heightManager.notifyHeight(entity.id, itemHeight);
    if (scrollController.position.pixels > 30) {
      scrollController.position.correctBy(itemHeight);
    }
    _entities.insert(0, entity);
    _currentBubbles.insert(0, w);
    notifyListeners();
  }

  void _onOldMessageAddition(ChatEntity entity) {
    final w = ChatBubble(
      key: ValueKey(entity.id),
      chatEntity: entity,
    );
    final ro = w.createRenderObject(context);
    ro.layout(BoxConstraints(maxWidth: MediaQuery.of(context).size.width));

    double itemHeight = ro.size.height;

    heightManager.notifyHeight(entity.id, itemHeight);

    _entities.add(entity);
    _currentBubbles.add(w);
    notifyListeners();
  }

  void onNewMessage(ChatEntity entity) {
    if (inScroll) {
      _onBufferizeNewMessages(entity);
    } else {
      _onNewMessageAddition(entity);
    }
  }

  void onOldMessages(List<ChatEntity> entities) {
    if (entities.isEmpty) {
      loaderState = ChatLoaderIndicatorStateType.empty;
      notifyListeners();
      return;
    }
    for (final e in entities) {
      _onOldMessageAddition(e);
    }
    loaderState = ChatLoaderIndicatorStateType.idle;
    notifyListeners();
  }

  void _onOldMessageRequest() async {
    if (loaderState == ChatLoaderIndicatorStateType.idle) {
      loaderState = ChatLoaderIndicatorStateType.loading;
      notifyListeners();
      await onLoadMore(_entities.last);
    }
  }

  void _add100NewMessage() {
    for (var i = 0; i < 100; i++) {
      _addNewMessage();
    }
  }

  void jumpToStart() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
  }
}
