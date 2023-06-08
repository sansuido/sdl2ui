import '../../../node.dart';
import '../../internal/action.dart';
import '../../internal/action_interval.dart';

class ActionEase extends ActionInterval {
  late Action innerAction;

  ActionEase(this.innerAction) {
    initWithDuration(innerAction.getDuration());
  }

  @override
  void startWithTarget(Node? target) {
    super.startWithTarget(target);
    innerAction.startWithTarget(target);
  }

  @override
  void stop() {
    super.stop();
    innerAction.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    innerAction.update(dt);
  }
}
