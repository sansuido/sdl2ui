import 'dart:math' as math;
import 'package:sdl2/sdl2.dart';
import 'package:sdl2ui/sdl2ui.dart' as ui;

class LocalWindow extends ui.Window {
  @override
  Future draw(ui.NodeContext context) async {
    var director = getAncestor<ui.Director>()!;
    var bb = getWorldBoundingBox();
    context.renderer.stringColor(bb.topLeft + math.Point(8, 8), 'FPS:${director.fps.getMeasFramerate()}', SdlColorEx.red);
  }
}

class LocalDirector extends ui.Director {
  @override
  Future ctor() async {
    await super.ctor();
    await addChild(LocalWindow()..create(
      title: 'demo',
      w: 640,
      h: 360,
      flags: SDL_WINDOW_RESIZABLE
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