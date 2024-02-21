import 'dart:math' as math;
import 'internal/action_ease.dart';

class EaseSineOut extends ActionEase {
  EaseSineOut(super.innerAction);

  @override
  void update(double dt) {
    super.update(dt);
    double value = dt;
    if (dt != 0 && dt != 1) {
      value = math.sin(dt * math.pi / 2);
    }
    innerAction.update(value);
  }
}
