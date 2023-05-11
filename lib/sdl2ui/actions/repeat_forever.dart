
import '../node.dart';
import 'internal/action.dart';
import 'internal/action_interval.dart';

class RepeatForever extends ActionInterval {

  late Action innerAction;
  RepeatForever(this.innerAction);

  @override
  void startWithTarget(Node? target) {
    super.startWithTarget(target);
    innerAction.startWithTarget(target);
  }

  @override
  bool isDone() => false;
  
  @override
  void step(double dt) {
    innerAction.step(dt);
    if (innerAction.isDone()) {
      innerAction.startWithTarget(getTarget());
      innerAction.step(innerAction.getElapsed() - innerAction.getDuration());
    }
  }
}