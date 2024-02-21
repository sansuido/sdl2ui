import 'dart:math';

import 'package:sdl2/sdl2.dart';
import 'package:sdl2ui/sdl2ui.dart' as ui;

class SystemColors {
  static int buttonFace = SdlColorEx.rgbaToU32(192, 192, 192, 255);
  static int buttonShadow = SdlColorEx.rgbaToU32(128, 128, 128, 255);
  static int buttonLight = SdlColorEx.rgbaToU32(223, 223, 223, 255);
  static int buttonAlternateFace = SdlColorEx.rgbaToU32(181, 181, 181, 255);
}

class LocalToggleButton extends ui.ToggleButton {
  LocalToggleButton(
      {required super.offNormal,
      super.offSelected,
      super.onNormal,
      super.onSelected,
      super.onToggle})
      : super(padding: 1, shift: Point<double>(1, 1));

  @override
  Future draw(ui.NodeContext context) async {
    var bb = getWorldBoundingBox();
    await super.draw(context);
    switch (getState()) {
      case 'normal':
        context.renderer.boxColor(bb, SystemColors.buttonFace);
        context.renderer
            .lineColor(bb.topLeft, bb.topRight, SystemColors.buttonLight);
        context.renderer
            .lineColor(bb.topLeft, bb.bottomLeft, SystemColors.buttonLight);
        context.renderer.lineColor(
            bb.bottomLeft, bb.bottomRight, SystemColors.buttonShadow);
        context.renderer
            .lineColor(bb.topRight, bb.bottomRight, SystemColors.buttonShadow);
        break;
      case 'selected':
        context.renderer.boxColor(bb, SystemColors.buttonAlternateFace);
        context.renderer
            .lineColor(bb.topLeft, bb.topRight, SystemColors.buttonShadow);
        context.renderer
            .lineColor(bb.topLeft, bb.bottomLeft, SystemColors.buttonShadow);
        context.renderer
            .lineColor(bb.bottomLeft, bb.bottomRight, SystemColors.buttonLight);
        context.renderer
            .lineColor(bb.topRight, bb.bottomRight, SystemColors.buttonLight);
        break;
    }
  }
}

class LocalWindow extends ui.Window {
  var color = 0;
  var colorList = [0, 0, 0, 0xff];

  @override
  Future ctor() async {
    super.ctor();
    var window = getAncestor<ui.Window>()!;
    for (var i = 0; i < 3; i++) {
      var toggleButton = LocalToggleButton(
          offNormal: ui.SpriteFrame(window.image.loadTexture(
              'assets/google_icons/1x/outline_visibility_off_black_24dp.png')),
          offSelected: ui.SpriteFrame(window.image.loadTexture(
              'assets/google_icons/1x/outline_visibility_off_white_24dp.png')),
          onNormal: ui.SpriteFrame(window.image.loadTexture(
              'assets/google_icons/1x/outline_visibility_black_24dp.png')),
          onSelected: ui.SpriteFrame(window.image.loadTexture(
              'assets/google_icons/1x/outline_visibility_white_24dp.png')),
          onToggle: (button, toggle) async {
            if (toggle) {
              colorList[i] = 0xff;
            } else {
              colorList[i] = 0x00;
            }
            _refreshColor();
          });
      toggleButton
          .setPosition(Point<double>(48, 32) * 0.5 + Point<double>(i * 48, 0));
      toggleButton.setContentSize(Point<double>(48, 32));
      await addChild(toggleButton);
      _refreshColor();
    }
  }

  void _refreshColor() {
    color = SdlColorEx.rgbaToU32(
        colorList[0], colorList[1], colorList[2], colorList[3]);
  }

  @override
  Future draw(ui.NodeContext context) async {
    var bb = getWorldBoundingBox();
    context.renderer.boxColor(bb, color);
  }
}

class LocalDirector extends ui.Director {
  @override
  Future ctor() async {
    super.ctor();
    await addChild(LocalWindow()
      ..create(
        title: 'color toggle button',
        w: 640,
        h: 480,
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
