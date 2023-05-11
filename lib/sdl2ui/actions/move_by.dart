import 'dart:math' as math;

import '../node.dart';
import 'internal/action_interval.dart';

class MoveBy extends ActionInterval {

  late math.Point<double> _positionDelta;
  late math.Point<double> _startPosition;
  //late math.Point<double> _previosPosition;

  void setPositionDelta(math.Point<double> positionDelta) => _positionDelta = positionDelta;

  MoveBy(duration, math.Point<double> position) : super(duration: duration) {
    initWithPosition(duration, position);
  }

  void initWithPosition(double duration, math.Point<double> position) {
    initWithDuration(duration);
    _positionDelta = position;
  }

  @override
  void startWithTarget(Node? target) {
    super.startWithTarget(target);
    if (target != null) {
      //_previosPosition = target.getPosition();
      _startPosition = target.getPosition();
    }
  }

  @override
  void update(double dt) {
    var target = getTarget();
    if (target != null) {
      var calc = math.Point(_positionDelta.x * dt, _positionDelta.y * dt);
      target.setPosition(_startPosition + calc);
    }
  }
}