import '../internal/action.dart';
import 'internal/action_ease.dart';

class EaseBackInOut extends ActionEase {
  EaseBackInOut(Action innerAction) : super(innerAction);

  @override
  void update(double dt) {
    super.update(dt);
    double overshoot = 1.70158 * 1.525;
    double value = 0;
    dt = dt * 2;
    if (dt < 1) {
      value = (dt * dt * ((overshoot + 1) * dt - overshoot)) / 2;
    } else {
      dt = dt - 2;
      value = (dt * dt * ((overshoot + 1) * dt + overshoot)) / 2 + 1;
    }
    innerAction.update(value);
  }
}