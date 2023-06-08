import 'dart:math' as math;
import 'package:sdl2/sdl2.dart';
import 'package:sdl2ui/sdl2ui.dart' as ui;

class LocalBox extends ui.Node {
  late int color;

  LocalBox(this.color);

  @override
  Future draw(ui.NodeContext context) async {
    var bb = getWorldBoundingBox();
    await super.draw(context);
    context.renderer.boxColor(bb, color);
  }
}

class LocalWindow extends ui.Window {
  @override
  Future ctor() async {
    await super.ctor();
    // parent
    var parentBox = LocalBox(SdlColorEx.rgbaToU32(255, 0, 0, 128));
    parentBox.setContentSize(getContentSize() * 0.25);
    parentBox.setScale(3.5);
    parentBox.setAnchorPoint(math.Point(1, 1));
    parentBox.setPosition(getContentSize());
    addChild(parentBox);
    // child
    var childBox = LocalBox(SdlColorEx.rgbaToU32(0, 255, 0, 128));
    childBox.setContentSize(parentBox.getContentSize() * 0.25);
    childBox.setScale(3.5);
    childBox.setAnchorPoint(math.Point(1, 1));
    childBox.setPosition(parentBox.getContentSize());
    parentBox.addChild(childBox);
    // granChild
    var grandChildBox = LocalBox(SdlColorEx.rgbaToU32(0, 0, 255, 128));
    grandChildBox.setContentSize(childBox.getContentSize() * 0.25);
    grandChildBox.setScale(3.5);
    grandChildBox.setAnchorPoint(math.Point(1, 1));
    grandChildBox.setPosition(childBox.getContentSize());
    childBox.addChild(grandChildBox);
    // parent move action
    action.addAction(
        ui.Sequence([
          ui.DelayTime(1.0),
          ui.MoveBy(0.5, math.Point(-30, 0)),
          ui.DelayTime(1.0),
          ui.MoveBy(0.5, math.Point(0, -30)),
          ui.DelayTime(1.0),
          ui.MoveBy(0.5, math.Point(30, 0)),
          ui.DelayTime(1.0),
          ui.MoveBy(0.5, math.Point(0, 30)),
          ui.DelayTime(1.0),
          // delay and remove
          ui.DelayTime(3.0),
          ui.RemoveSelf(),
        ]),
        parentBox,
        false);
    // child move action
    action.addAction(
        ui.Sequence([
          ui.DelayTime(1.0),
          ui.MoveBy(1.0, math.Point(-20, 0)),
          ui.DelayTime(0.5),
          ui.MoveBy(1.0, math.Point(0, -20)),
          ui.DelayTime(0.5),
          ui.MoveBy(1.0, math.Point(20, 0)),
          ui.DelayTime(0.5),
          ui.MoveBy(1.0, math.Point(0, 20)),
          ui.DelayTime(0.5),
          // delay and remove
          ui.DelayTime(2.0),
          ui.RemoveSelf(),
        ]),
        childBox,
        false);
    // granChild move action
    action.addAction(
        ui.Sequence([
          ui.DelayTime(1.0),
          ui.MoveBy(1.5, math.Point(-5, 0)),
          ui.MoveBy(1.5, math.Point(0, -5)),
          ui.MoveBy(1.5, math.Point(5, 0)),
          ui.MoveBy(1.5, math.Point(0, 5)),
          // delay and remove
          ui.DelayTime(1.0),
          ui.RemoveSelf(),
        ]),
        grandChildBox,
        false);
  }
}

class LocalDirector extends ui.Director {
  @override
  Future ctor() async {
    await super.ctor();
    await addChild(LocalWindow()
      ..create(
          title: 'scale and child elements',
          w: 640,
          h: 360,
          flags: SDL_WINDOW_RESIZABLE));
  }
}

Future main() async {
  var director = LocalDirector();
  if (await director.init()) {
    await director.run();
  }
  director.quit();
}
