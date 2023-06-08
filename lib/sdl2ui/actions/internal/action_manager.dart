import '../../node.dart';
import 'action.dart';

class ActionHashElement {
  var actionList = <Action>[];
  Node? target;
  var actionIndex = 0;
  Action? currentAction;
  var currentActionSalvaged = false;
  var paused = false;
}

class ActionManager {
  final _hashTargetList = <Node, ActionHashElement>{};

  void addAction(Action action, Node target, bool paused) {
    var element = _hashTargetList[target];
    if (element == null) {
      element = ActionHashElement();
      element.target = target;
      element.paused = paused;
      _hashTargetList[target] = element;
    }
    element.actionList.add(action);
    action.startWithTarget(target);
  }

  void removeAllActionsFromTarget(Node target) {
    var element = _hashTargetList[target];
    if (element != null) {
      removeHashElement(element);
    }
  }

  void removeHashElement(ActionHashElement element) {
    _hashTargetList.remove(element);
  }

  void resumeTarget(Node target) {
    var element = _hashTargetList[target];
    if (element != null) {
      element.paused = false;
    }
  }

  void pauseTarget(Node target) {
    var element = _hashTargetList[target];
    if (element != null) {
      element.paused = true;
    }
  }

  void removeAction(Action action) {
    var target = action.getTarget();
//    var target = action.getOriginalTarget();
    if (target != null) {
      var element = _hashTargetList[target];
      if (element != null) {
        element.actionList.remove(action);
      }
    }
  }

  void removeActionByTag(String tag, Node target) {
    var element = _hashTargetList[target];
    if (element != null) {
      var action = getActionByTag(tag, target);
      if (action != null) {
        element.actionList.remove(action);
      }
    }
  }

  Action? getActionByTag(String tag, Node target) {
    Action? result;
    var element = _hashTargetList[target];
    if (element != null) {
      for (var action in element.actionList) {
        if (action.getTag() == tag) {
          result = action;
          break;
        }
      }
    }
    return result;
  }

  void update(double dt) {
    var targetList = _hashTargetList.values;
    for (var target in targetList) {
      if (target.paused == true) {
        continue;
      }
      var actionList = [...target.actionList];
      for (var action in actionList) {
        target.currentAction = action;
        target.currentActionSalvaged = false;
        target.currentAction!.step(dt * 1);
        if (target.currentActionSalvaged == true) {
          target.currentAction = null;
        } else if (target.currentAction!.isDone() == true) {
          target.currentAction!.stop();
          removeAction(action);
        }
        target.currentAction = null;
      }
    }
  }
}
