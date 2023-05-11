import '../internal/action.dart';
import 'internal/ease_bounce.dart';

class EaseBounceIn extends EaseBounce {
  EaseBounceIn(Action innerAction) : super(innerAction);

  @override
  void update(double dt) {
    var value = 1 - bounceTime(1- dt);
    innerAction.update(value);
  }
}