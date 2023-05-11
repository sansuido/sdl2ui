
import 'finite_time_action.dart';

class ActionInstant extends FiniteTimeAction {

  ActionInstant() : super(0);

  @override
  bool isDone() => true;
  @override
  void step(double dt) => update(1);

}