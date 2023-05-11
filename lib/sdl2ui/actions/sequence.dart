
import '../node.dart';
import 'internal/action.dart';
import 'internal/action_interval.dart';

class Sequence extends ActionInterval {
  late List<Action> _actionList;
  double _split = 0;
  var _last = -1;
  
  Sequence([List<Action>? actions]) {
    if (actions != null && actions.isNotEmpty) {
      var prev = actions[0];
      for (var index = 1; index < actions.length - 1; index++) {
        var seq = Sequence();
        seq.initWithTowActions(prev, actions[index]);
        prev = seq;
      }
      initWithTowActions(prev, actions[actions.length - 1]);
    }
  }

  void initWithTowActions(Action actionOne, Action actionTwo) {
    var duration = actionOne.getDuration() + actionTwo.getDuration();
    initWithDuration(duration);
    _actionList = [];
    _actionList.add(actionOne);
    _actionList.add(actionTwo);
  }

  @override
  void startWithTarget(Node? target) {
    super.startWithTarget(target);
    _split = _actionList[0].getDuration() / getDuration();
    _last = -1;
  }

  @override
  void stop() {
    if (_last != -1) {
      _actionList[_last].stop();
    }
    super.stop();
  }

  @override
  void update(double dt) {
    var found = 0;
    double newDt = 0.0;
    if (dt < _split) {
      newDt = 1;
      if (_split != 0) {
        newDt = dt / _split;
      }
      if (_last == 1) {
        _actionList[_last].update(0);
        _actionList[_last].stop();
      }
    } else {
      found = 1;
      if (_split == 1) {
        newDt = 1;
      } else {
			  newDt = (dt - _split) / (1 - _split);
      }
      if (_last == -1) {
        _actionList[0].startWithTarget(getTarget());
        _actionList[0].update(1);
        _actionList[0].stop();
      }
      if (_last == 0) {
        _actionList[0].update(1);
        _actionList[0].stop();
      }
    }
    var actionFound = _actionList[found];
    if (_last == found && actionFound.isDone()) {
      return;
    }
    if (_last != found) {
      actionFound.startWithTarget(getTarget());
    }
    newDt = newDt * actionFound.getTimesForRepeat();
    if (newDt > 1) {
      newDt %= 1;
    }
    actionFound.update(newDt);
    _last = found;
  }
}