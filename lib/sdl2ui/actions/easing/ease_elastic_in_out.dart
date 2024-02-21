import 'dart:math' as math;
import 'internal/action_ease.dart';

class EaseElasticInOut extends ActionEase {
  EaseElasticInOut(super.innerAction);

  @override
  void update(double dt) {
    // https://easings.net/ja#easeInOutElastic
    var value = dt;
    var c5 = (2 * math.pi) / 4.5;
    if (dt != 0 && dt != 1) {
      if (dt < 0.5) {
        value =
            -(math.pow(2, 20 * dt - 10) * math.sin((20 * dt - 11.125) * c5)) /
                2;
      } else {
        value =
            (math.pow(2, -20 * dt + 10) * math.sin((20 * dt - 11.125) * c5)) /
                    2 +
                1;
      }
    }
    innerAction.update(value);
  }
}
