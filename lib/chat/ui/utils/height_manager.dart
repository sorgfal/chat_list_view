abstract class HeightManager {
  void notifyHeight(int id, double height);
  double get total;
  double? operator [](int key);
}

HeightManager heightManager = _HeightManager();

class _HeightManager extends HeightManager {
  late Map<int, double> _height = {};
  @override
  void notifyHeight(int id, double height) {
    _height[id] = height;
  }

  @override
  double? operator [](int key) {
    return _height[key];
  }

  @override
  double get total => _height.values
      .fold(0, (previousValue, element) => previousValue + element);
}
