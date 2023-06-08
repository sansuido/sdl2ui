import 'dart:ffi';
import 'dart:math';
import 'package:sdl2/sdl2.dart';

class SpriteFrame {
  Pointer<SdlTexture> texture;
  late Rectangle<double> rect;
  SpriteFrame(this.texture, [Rectangle<double>? rect]) {
    if (rect == null) {
      var size = texture.getSize()!;
      this.rect = RectangleEx.fromLTWH(Point<double>(0, 0), size);
    } else {
      this.rect = rect;
    }
  }
}
