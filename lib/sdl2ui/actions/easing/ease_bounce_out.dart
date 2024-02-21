import 'internal/ease_bounce.dart';

class EaseBounceOut extends EaseBounce {
  EaseBounceOut(super.innerAction);

  @override
  void update(double dt) {
    var value = bounceTime(dt);
    innerAction.update(value);
  }
}
