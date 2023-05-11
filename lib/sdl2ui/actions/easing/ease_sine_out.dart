import 'dart:math' as math;
import '../internal/action.dart';
import 'internal/action_ease.dart';

class EaseSineOut extends ActionEase {
  EaseSineOut(Action innerAction) : super(innerAction);

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