import 'dart:math';
import 'package:sdl2/sdl2.dart';
import '../node.dart' as ui;
import '../sprite.dart' as ui;
import '../sprite_frame.dart' as ui;
import '../events/event_mouse_manager.dart' as ui;

class Button extends ui.Node {
  ui.SpriteFrame normal;
  ui.SpriteFrame? selected;

  ui.Sprite? sprite;
  String _state = '';
  double? padding;
  Point<double>? shift;
  Future Function(Button)? onClick;

  Button(
      {required this.normal,
      this.onClick,
      this.selected,
      this.padding,
      this.shift}) {
    setContentSize(normal.rect.size);
    setAnchorPoint(Point<double>(0.5, 0.5));
  }

  String getState() => _state;
  double? getPadding() => padding;
  void setPadding(double setPadding) => padding = setPadding;
  Point<double>? getShift() => shift;
  void setShift(Point<double> setShift) => shift = setShift;

  void reloadSpriteFrame(String state, ui.SpriteFrame? spriteFrame) {
    switch (state) {
      case 'normal':
        if (spriteFrame != null) {
          normal = spriteFrame;
        }
        break;
      case 'selected':
        selected = spriteFrame;
        break;
    }
    _reloadState();
  }

  void _reloadState() {
    if (_state == 'selected') {
      sprite!.setPosition(Point<double>(padding ?? 0, padding ?? 0) +
          (shift ?? Point<double>(0, 0)));
      if (selected != null) {
        sprite!.setSpriteFrame(selected!);
      }
    } else {
      sprite!.setPosition(Point<double>(padding ?? 0, padding ?? 0));
      sprite!.setSpriteFrame(normal);
    }
  }

  void _swapState(String state) {
    if (sprite != null) {
      if (_state != state) {
        _state = state;
        _reloadState();
      }
    }
  }

  @override
  Future ctor() async {
    await super.ctor();
    // normal
    sprite = ui.Sprite(normal.texture);
    sprite!.setAnchorPoint(Point<double>(0, 0));
    sprite!.setContentSize(getContentSize() -
        Point<double>((padding ?? 0) * 2, (padding ?? 0) * 2));
    _swapState('normal');
    await addChild(sprite!);
    var eventMouse = ui.EventMouse();
    eventMouse.setMouseDown((eventMouse, _) async {
      var hover = getWorldIntersectBox();
      if (hover != null && hover.containsPoint(eventMouse.position) == true) {
        eventMouse.setCapture(this);
        _swapState('selected');
        return true;
      } else {
        _swapState('normal');
      }
      return false;
    });
    eventMouse.setMouseUp((eventMouse, _) async {
      _swapState('normal');
      if (eventMouse.isCapture(this)) {
        var hover = getWorldIntersectBox();
        eventMouse.removeCapture();
        if (hover != null && hover.containsPoint(eventMouse.position) == true) {
          if (onClick != null) {
            await onClick!(this);
          }
        }
        return true;
      }
      return false;
    });
    eventMouse.setMouseMove((eventMouse, _) async {
      if (eventMouse.isCapture(this)) {
        var hover = getWorldIntersectBox();
        if (hover != null && hover.containsPoint(eventMouse.position) == true) {
          _swapState('selected');
        } else {
          _swapState('normal');
        }
        return true;
      }
      return false;
    });
    addEvent(eventMouse);
  }

  @override
  void setContentSize(Point<double> contentSize) {
    super.setContentSize(contentSize);
    if (sprite != null) {
      sprite!.setContentSize(getContentSize() -
          Point<double>((padding ?? 0) * 2, (padding ?? 0) * 2));
      _reloadState();
    }
  }
}
