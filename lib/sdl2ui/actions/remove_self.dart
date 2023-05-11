
import 'internal/action_instant.dart';

class RemoveSelf extends ActionInstant {
  
  //late bool isNeedCleanUp;
  //RemoveSelf(this.isNeedCleanUp);

  @override
  void update(double dt) {
    var target = getTarget();
    if (target != null) {
      target.removeFromParent();
    }
  }
}