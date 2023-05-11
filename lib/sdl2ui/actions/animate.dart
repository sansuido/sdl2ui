import '../node.dart';
import '../sprite.dart';
import 'internal/action_interval.dart';
import '../animation.dart';

class Animate extends ActionInterval {

  late int _nextFrame;
  late Animation _animation;
  late List<double> _splitTimes;

  Animate(Animation animation) {
    initWithAnimation(animation);
  }

  void initWithAnimation(Animation animation) {
    super.initWithDuration(animation.getDuration() * animation.getLoops());
    _nextFrame = 0;
    _animation = animation;
    _splitTimes = [];
    var singleDuration = animation.getDuration();
    var accumUnitsOfTime = 0.0;
    var newUnitOfTimeValue = singleDuration / animation.getTotalDelayUnits();
    var animationFrames = animation.getAnimationFrames();
    for (var animationFrame in animationFrames) {
      var value = (accumUnitsOfTime * newUnitOfTimeValue) / singleDuration;
      accumUnitsOfTime += animationFrame.delayPerUnits;
      _splitTimes.add(value);
    }
  }

  @override
  void startWithTarget(Node? target) {
    super.startWithTarget(target);
    _nextFrame = 0;
  }

  @override
  void update(double dt) {
    var animationFrames = _animation.getAnimationFrames();
    if (dt < 1.0) {
      dt *= _animation.getLoops();
      dt %= 1.0;
    }
    for (var i = _nextFrame; i < animationFrames.length; i++) {
      if (_splitTimes[i] <= dt) {
        var target = getTarget();
        if (target != null && target is Sprite) {
          target.setSpriteFrame(animationFrames[i].spriteFrame);
        }
        _nextFrame = i + 1;
      }
      else {
        break;
      }
    }
  }
}