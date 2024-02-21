import 'dart:math' as math;
import 'package:sdl2/sdl2.dart';
import 'package:sdl2ui/sdl2ui.dart' as ui;

class LocalWindow extends ui.Window {
  bool toggle = false;

  @override
  Future ctor() async {
    await super.ctor();
    // create sprite(hello world)
    var texture = ttf.loadTexture('Hello world.',
        fontFile: 'assets/SourceHanCodeJP-Normal.otf',
        fontSize: 64,
        textColor: SdlColorEx.black,
        backgroundColor: SdlColorEx.red);
    var sprite = ui.Sprite(texture);
    sprite.setPosition(getContentSize() * 0.5);
    await addChild(sprite);
    // add action (repeat forever)
    var rect = math.Rectangle<double>(0, 0, 640, 360).expansion(-200);
    action.addAction(
        ui.RepeatForever(ui.Sequence([
          ui.EaseSineInOut(ui.MoveTo(3.0, rect.topLeft)),
          ui.EaseSineInOut(ui.MoveTo(3.0, rect.topRight)),
          ui.EaseSineInOut(ui.MoveTo(3.0, rect.bottomRight)),
          ui.EaseSineInOut(ui.MoveTo(3.0, rect.bottomLeft)),
        ]))
          ..setTag('forever'),
        sprite,
        false);
    // click (pause and resume)
    var eventMouse = ui.EventMouse();
    eventMouse.setMouseDown((event, _) async {
      if ((event.state & SDL_BUTTON_LEFT) != 0) {
        toggle = !toggle;
        if (toggle == true) {
          action.pauseTarget(sprite);
        } else {
          action.resumeTarget(sprite);
        }
        return true;
      }
      return false;
    });
    addEvent(eventMouse);
  }
}

class LocalDirector extends ui.Director {
  @override
  Future ctor() async {
    await super.ctor();
    // create new window
    await addChild(LocalWindow()
      ..create(
        title: 'hello world (click: stop | resume)',
        w: 640,
        h: 360,
      ));
  }
}

Future main() async {
  var director = LocalDirector();
  if (await director.init()) {
    await director.run();
  }
  director.quit();
}
