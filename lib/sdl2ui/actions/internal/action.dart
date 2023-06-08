import '../../node.dart';

class Action {
  //Node? _originalTarget;
  Node? _target;
  String? _tag;

  void startWithTarget(Node? target) {
    //_originalTarget = target;
    _target = target;
  }

  void stop() {
    _target = null;
  }

  void step(double dt) {}
  void update(double dt) {}
  bool isDone() => true;
  double getDuration() => 0;
  int getTimesForRepeat() => 1;
  double getElapsed() => 0;
  Node? getTarget() => _target;
  //Node? getOriginalTarget() => _originalTarget;

  String? getTag() => _tag;

  void setTag(String? tag) {
    _tag = tag;
  }
}
