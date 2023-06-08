import '../../internal/action.dart';
import 'action_ease.dart';

class EaseBounce extends ActionEase {
  EaseBounce(Action innerAction) : super(innerAction);

  double bounceTime(double time1) {
    if (time1 < (1 / 2.75)) {
      return 7.5625 * time1 * time1;
    } else if (time1 < (2 / 2.75)) {
      time1 = time1 - 1.5 / 2.75;
      return 7.5625 * time1 * time1 + 0.75;
    } else if (time1 < (2.5 / 2.75)) {
      time1 = time1 - 2.25 / 2.75;
      return 7.5625 * time1 * time1 + 0.9375;
    }
    time1 = time1 - 2.625 / 2.75;
    return 7.5625 * time1 * time1 + 0.984375;
  }
}
