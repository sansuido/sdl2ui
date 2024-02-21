import 'internal/action_ease.dart';

class EaseBackIn extends ActionEase {
  EaseBackIn(super.innerAction);

  @override
  void update(double dt) {
    super.update(dt);
    double overshoot = 1.70158;
    double value = dt;
    if (dt != 0 && dt != 1) {
      value = dt * dt * ((overshoot + 1) * dt - overshoot);
    }
    innerAction.update(value);
  }
}
