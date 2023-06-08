import 'dart:math' as math;
import '../node.dart';
import 'move_by.dart';

class MoveTo extends MoveBy {
  late math.Point<double> _endPosition;

  MoveTo(double duration, math.Point<double> position)
      : super(duration, position) {
    initWithPosition(duration, position);
  }

  @override
  void initWithPosition(double duration, math.Point<double> position) {
    super.initWithPosition(duration, position);
    _endPosition = position;
  }

  @override
  void startWithTarget(Node? target) {
    super.startWithTarget(target);
    setPositionDelta(_endPosition - target!.getPosition());
  }
}
