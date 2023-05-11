import '../internal/action.dart';
import 'internal/ease_bounce.dart';

class EaseBounceInOut extends EaseBounce {
  EaseBounceInOut(Action innerAction) : super(innerAction);

  @override
  void update(double dt) {
    var value = 0.0;
    if (dt < 0.5) {
      dt *= 2;
      value = (1 - bounceTime(1- dt)) * 0.5;
    } else {
      value = bounceTime(dt * 2 - 1) * 0.5 + 0.5;
    }
    innerAction.update(value);
  }
}