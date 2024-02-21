import 'package:sdl2ui/sdl2ui.dart' as ui;
import 'package:sdl2/sdl2.dart';

class LocalBox extends ui.Control {
  @override
  Future draw(ui.NodeContext context) async {
    await super.draw(context);
    var bb = getWorldBoundingBox();
    context.renderer.rectangleColor(bb, SdlColorEx.rgbaToU32(255, 0, 0, 0x80));
    context.renderer.boxColor(bb, SdlColorEx.rgbaToU32(0, 0, 255, 0x80));
  }
}

class LocalWindow extends ui.Window {
  var localBoxes = <LocalBox>[];
  @override
  Future ctor() async {
    await super.ctor();
    var window = getAncestor<ui.Window>()!;
    // outframe
    var outFrameBoxSizer = ui.BoxSizer();
    await addChild(outFrameBoxSizer);
    // header
    var header = LocalBox()
      ..szHeight = 30
      ..szBorder = 0;
    await outFrameBoxSizer.addChild(header);
    // headerBoxSizer
    var headerBoxSizer = ui.BoxSizer(horizontal: true);
    await header.addChild(headerBoxSizer);
    // add inner
    var inFrameBoxSizer = ui.BoxSizer(horizontal: true);
    localBoxes.add(LocalBox());
    await inFrameBoxSizer.addChild(localBoxes[0]
      ..szWidth = 100
      ..szHeight = 200
      ..szAlign = 0);
    await inFrameBoxSizer.addChild(ui.Spacer());
    localBoxes.add(LocalBox());
    await inFrameBoxSizer.addChild(localBoxes[1]
      ..szHeight = 200
      ..szAlign = 0.5
      ..szFactor = 4);
    await inFrameBoxSizer.addChild(ui.Spacer());
    localBoxes.add(LocalBox());
    await inFrameBoxSizer.addChild(localBoxes[2]
      ..szHeight = 200
      ..szAlign = 1.0);
    await outFrameBoxSizer.addChild(inFrameBoxSizer);
    // footer
    await outFrameBoxSizer.addChild(LocalBox()
      ..szHeight = 30
      ..szBorder = 0);
    // add buttons
    await headerBoxSizer.addChild(ui.Spacer()..szWidth = -1);
    for (var i = 0; i < 3; i++) {
      var button = ui.Button(
        normal: ui.SpriteFrame(window.image.loadTexture(
            'assets/google_icons/1x/outline_visibility_black_24dp.png')),
        selected: ui.SpriteFrame(window.image.loadTexture(
            'assets/google_icons/1x/outline_visibility_white_24dp.png')),
        onClick: (button) async {
          var redBox = localBoxes[i];
          // up or down
          if (redBox.szAlign == 0) {
            redBox.szAlign = 1;
          } else if (redBox.szAlign == 1) {
            redBox.szAlign = 0;
          } else {
            // expand or fixed
            if (redBox.szHeight == -1) {
              redBox.szHeight = 200;
              redBox.szFactor = 4;
            } else {
              redBox.szHeight = -1;
              redBox.szFactor = 1;
            }
          }
          await window.requestResize();
        },
      );
      button.szWidth = 24;
      button.szHeight = 24;
      await headerBoxSizer.addChild(button);
    }
  }
}

class LocalDirector extends ui.Director {
  @override
  Future ctor() async {
    super.ctor();
    await addChild(LocalWindow()
      ..create(
          title: 'box sizer demo',
          w: 640,
          h: 480,
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
