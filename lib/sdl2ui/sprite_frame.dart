import 'dart:ffi';
import 'dart:math';
import 'package:sdl2/sdl2.dart';

class SpriteFrame {
  Pointer<SdlTexture> texture;
  Rectangle<double> rect;
  SpriteFrame(this.texture, this.rect);
}