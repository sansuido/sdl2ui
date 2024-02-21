import 'dart:math' as math;
import 'internal/action_ease.dart';

class EaseElasticOut extends ActionEase {
  EaseElasticOut(super.innerAction);

  @override
  void update(double dt) {
    // https://easings.net/ja#easeOutElastic
    var value = dt;
    if (dt != 0 && dt != 1) {
      var c4 = (2 * math.pi) / 3;
      value = math.pow(2, -10 * dt) * math.sin((dt * 10 - 0.75) * c4) + 1;
    }
    innerAction.update(value);
  }
}
