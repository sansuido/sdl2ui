import '../../node.dart';
import 'finite_time_action.dart';

class ActionInterval extends FiniteTimeAction {
  var _timesForRepeat = 1;
  //var _timeForRepeat = 0;
  var _firstTick = false;
  var _elapsed = 0.0;
  final _repeatForever = false;
  final _repeatMethod = false;

  ActionInterval({double duration = 0}) : super(duration);

  void initWithDuration(double duration) {
    setDuration(duration);
    _elapsed = 0;
    _firstTick = true;
  }

  @override
  double getElapsed() => _elapsed;

  @override
  bool isDone() {
    return _elapsed >= getDuration();
  }

  @override
  double getDuration() {
    return super.getDuration() * (_timesForRepeat > 1 ? _timesForRepeat : 1);
  }

  @override
  int getTimesForRepeat() {
    return _timesForRepeat;
  }

  @override
  void step(double dt) {
    if (_firstTick) {
      _firstTick = false;
      _elapsed = 0.0;
    } else {
      _elapsed += dt;
      var mul = getDuration();
      if (mul < 0.0000001192092896) {
        mul = 0.0000001192092896;
      }
      var tick = _elapsed / mul;
      if (tick > 1) {
        tick = 1;
      }
      if (tick < 0) {
        tick = 0;
      }
      update(tick);
      if (_repeatMethod && _timesForRepeat > 1 && isDone()) {
        if (_repeatForever == false) {
          _timesForRepeat += 1;
        }
        startWithTarget(getTarget());
        step(_elapsed - getDuration());
      }
    }
  }

  @override
  void startWithTarget(Node? target) {
    super.startWithTarget(target);
    _elapsed = 0;
    _firstTick = true;
  }
}
