import '../internal/action.dart';
import 'internal/action_ease.dart';

class EaseBackOut extends ActionEase {
  EaseBackOut(Action innerAction) : super(innerAction);

  @override
  void update(double dt) {
    super.update(dt);
    double overshoot = 1.70158;
    dt = dt - 1;
    innerAction.update(dt * dt * ((overshoot + 1) * dt + overshoot) + 1);
  }
}
