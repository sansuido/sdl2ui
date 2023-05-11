import 'dart:math' as math;
import '../internal/action.dart';
import 'internal/action_ease.dart';

class EaseElasticIn extends ActionEase {
  EaseElasticIn(Action innerAction) : super(innerAction);

  @override
  void update(double dt) {
    // https://easings.net/ja#easeInElastic
    var value = dt;
    if (dt != 0 && dt != 1) {
      var c4 = (2 * math.pi) / 3;
      value = -math.pow(2, 10 * dt - 10) * math.sin((dt * 10 - 10.75) * c4);
    }
    innerAction.update(value);
  }
}