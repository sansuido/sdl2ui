import 'dart:math' as math;
import 'package:sdl2/sdl2.dart';
import 'package:sdl2ui/sdl2ui.dart' as ui;

class LocalWindow extends ui.Window {
  @override
  Future ctor() async {
    await super.ctor();
    setLogicalSize(getContentSize() * 0.5);
    var texture = image.loadTexture('assets/laby.png');
    var sprite = ui.Sprite(texture,
        srcrect: RectangleEx.fromLTWH(
            math.Point<double>(0, 0), math.Point<double>(32, 32)));
    sprite.setAngle(270);
    sprite.setPosition(getContentSize() * 0.5);
    await addChild(sprite);
    action.addAction(
        ui.RepeatForever(
          ui.Animate(
            ui.Animation([
              ui.SpriteFrame(
                  texture,
                  RectangleEx.fromLTWH(
                      math.Point<double>(0, 0), math.Point<double>(32, 32))),
              ui.SpriteFrame(
                  texture,
                  RectangleEx.fromLTWH(
                      math.Point<double>(32, 0), math.Point<double>(32, 32))),
              ui.SpriteFrame(
                  texture,
                  RectangleEx.fromLTWH(
                      math.Point<double>(64, 0), math.Point<double>(32, 32))),
              ui.SpriteFrame(
                  texture,
                  RectangleEx.fromLTWH(
                      math.Point<double>(96, 0), math.Point<double>(32, 32))),
              ui.SpriteFrame(
                  texture,
                  RectangleEx.fromLTWH(
                      math.Point<double>(64, 0), math.Point<double>(32, 32))),
              ui.SpriteFrame(
                  texture,
                  RectangleEx.fromLTWH(
                      math.Point<double>(32, 0), math.Point<double>(32, 32))),
            ], 0.15, 1),
          ),
        )..setTag('animation'),
        sprite,
        false);
    var eventMouse = ui.EventMouse();
    eventMouse.setMouseDown((event, _) async {
      if ((event.state & SDL_BUTTON_LEFT) != 0) {
        action.removeActionByTag('move', sprite);
        var a = sprite.getPosition();
        var b = event.position;
        var angle = math.atan2(b.y - a.y, b.x - a.x) * 180 / math.pi;
        sprite.setAngle(angle);
        var distance = a.distanceTo(b);
        action.addAction(
            ui.EaseBackInOut(ui.MoveTo(distance / 100, b))..setTag('move'),
            sprite,
            false);
      }
      return true;
    });
    addEvent(eventMouse);
  }
}

class LocalDirector extends ui.Director {
  @override
  Future ctor() async {
    await super.ctor();
    // img open
    imgInit(IMG_INIT_PNG);
    // create new window
    await addChild(LocalWindow()
      ..create(
          title: 'animation (click: move)',
          w: 640,
          h: 360,
          flags: SDL_WINDOW_RESIZABLE));
  }

  @override
  Future destroy() async {
    await super.destroy();
    // img close
    imgQuit();
  }
}

Future main() async {
  var director = LocalDirector();
  if (await director.init()) {
    await director.run();
  }
  director.quit();
}
