import 'dart:math' as math;
import 'internal/action_ease.dart';

class EaseSineInOut extends ActionEase {
  EaseSineInOut(super.innerAction);

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
