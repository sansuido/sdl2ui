import 'sprite_frame.dart';
import 'internal/animation_frame.dart';

class Animation {
  double _delayPerUnit = 0;
  int _totalDelayUnits = 0;
  int _loops = 0;
  List<AnimationFrame> _animationFrames = [];

  Animation(List<SpriteFrame> spriteFrames, double delayPerUnit, int loops) {
    initWithSpriteFrames(spriteFrames, delayPerUnit, loops);
  }

  double getDuration() => _delayPerUnit * _animationFrames.length;
  double getDelayPerUnit() => _delayPerUnit;
  int getTotalDelayUnits() => _totalDelayUnits;
  int getLoops() => _loops;
  List<AnimationFrame> getAnimationFrames() => _animationFrames;

  void initWithSpriteFrames(
      List<SpriteFrame> spriteFrames, double delayPerUnit, int loops) {
    _delayPerUnit = delayPerUnit;
    _totalDelayUnits = 0;
    _loops = loops;
    _animationFrames = [];
    for (var spriteFrame in spriteFrames) {
      var animationFrame = AnimationFrame(spriteFrame, 1);
      _animationFrames.add(animationFrame);
    }
    _totalDelayUnits = _animationFrames.length;
  }
}
