import 'internal/ease_bounce.dart';

class EaseBounceIn extends EaseBounce {
  EaseBounceIn(super.innerAction);

  @override
  void update(double dt) {
    var value = 1 - bounceTime(1 - dt);
    innerAction.update(value);
  }
}
