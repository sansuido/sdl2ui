import 'dart:math' as math;
import 'internal/action_ease.dart';

class EaseSineIn extends ActionEase {
  EaseSineIn(super.innerAction);

  @override
  void update(double dt) {
    super.update(dt);
    double value = dt;
    if (dt != 0 && dt != 1) {
      value = -1 * math.cos(dt * math.pi / 2) + 1;
    }
    innerAction.update(value);
  }
}
