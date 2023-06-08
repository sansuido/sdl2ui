import 'dart:math' as math;
import '../internal/action.dart';
import 'internal/action_ease.dart';

class EaseSineInOut extends ActionEase {
  EaseSineInOut(Action innerAction) : super(innerAction);

  @override
  void update(double dt) {
    super.update(dt);
    double value = dt;
    if (dt != 0 && dt != 1) {
      value = -0.5 * (math.cos(math.pi * dt) - 1);
    }
    innerAction.update(value);
  }
}
