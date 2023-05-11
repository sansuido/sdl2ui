
import 'action.dart';

class FiniteTimeAction extends Action {

  late double duration;

  FiniteTimeAction(this.duration);

  @override
  double getDuration() {
    return duration;
  }
 
  void setDuration(double duration) {
    this.duration = duration;
  }
}