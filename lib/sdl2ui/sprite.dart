import 'dart:ffi';
import 'dart:math';
import 'package:sdl2/sdl2.dart';
import 'node.dart' as ui;
import 'node_context.dart' as ui;
import 'sprite_frame.dart';

class Sprite extends ui.Node {
  Pointer<SdlTexture> texture;
  Rectangle<double>? srcrect;
  bool _slice = false;
  double _angle = 0;
  bool _flipX = false;
  bool _flipY = false;

  Sprite(this.texture, {this.srcrect}) {
    setAnchorPoint(Point(0.5, 0.5));
    if (texture != nullptr) {
      setContentSize(texture.getSize()!);
    }
    if (srcrect != null) {
      setContentSize(srcrect!.size);
    }
  }

  double getAngle() => _angle;
  void setAngle(double angle) => _angle = angle;
  bool getSlice() => _slice;
  void setSlice(bool slice) => _slice = slice;
  bool getFlipX() => _flipX;
  void setFlipX(flipX) => _flipX = flipX;
  bool getFlipY() => _flipY;
  void setFlipY(flipY) => _flipY = flipY;

  void setSpriteFrame(SpriteFrame spriteFrame) {
    texture = spriteFrame.texture;
    srcrect = spriteFrame.rect;
  }

  Future drawNormal(ui.NodeContext context, Rectangle<double> bb) async {
    int flip = SDL_FLIP_NONE;
    if (_flipX) {
      flip |= SDL_FLIP_HORIZONTAL;
    }
    if (_flipY) {
      flip |= SDL_FLIP_VERTICAL;
    }
    context.renderer.copyEx(texture,
        dstrect: bb, srcrect: srcrect, angle: _angle, flip: flip);
  }

  Future drawSlice(ui.NodeContext context, Rectangle<double> bb) async {
    if (texture != nullptr) {
      var src =
          srcrect ?? RectangleEx.fromLTWH(Point(0, 0), texture.getSize()!);
      var size = src.size;
      var sliceX = (size.x / 3).ceil().toDouble();
      var sliceY = (size.y / 3).ceil().toDouble();
      var dstrectList = [
        RectangleEx.fromLTWH(bb.topLeft + Point(0, 0), Point(sliceX, sliceY)),
        RectangleEx.fromLTWH(bb.topLeft + Point(sliceX, 0),
            Point(bb.width - sliceX * 2, sliceY)),
        RectangleEx.fromLTWH(
            bb.topLeft + Point(bb.width - sliceX, 0), Point(sliceX, sliceY)),
        RectangleEx.fromLTWH(bb.topLeft + Point(0, sliceY),
            Point(sliceX, bb.height - sliceY * 2)),
        RectangleEx.fromLTWH(bb.topLeft + Point(sliceX, sliceY),
            Point(bb.width - sliceX * 2, bb.height - sliceY * 2)),
        RectangleEx.fromLTWH(bb.topLeft + Point(bb.width - sliceX, sliceY),
            Point(sliceX, bb.height - sliceY * 2)),
        RectangleEx.fromLTWH(
            bb.topLeft + Point(0, bb.height - sliceY), Point(sliceX, sliceY)),
        RectangleEx.fromLTWH(bb.topLeft + Point(sliceX, bb.height - sliceY),
            Point(bb.width - sliceX * 2, sliceY)),
        RectangleEx.fromLTWH(
            bb.topLeft + Point(bb.width - sliceX, bb.height - sliceY),
            Point(sliceX, sliceY)),
      ];
      var index = 0;
      for (var y = 0; y < 3; y++) {
        for (var x = 0; x < 3; x++) {
          var dstrect = dstrectList[index];
          context.renderer.copy(texture,
              dstrect: dstrect,
              srcrect: RectangleEx.fromLTWH(
                  Point(src.left + sliceX * x, src.top + sliceY * y),
                  Point(sliceX, sliceY)));
          index++;
        }
      }
    }
  }

  @override
  Future draw(ui.NodeContext context) async {
    await super.draw(context);
    var bb = getWorldBoundingBox();
    if (_slice) {
      await drawSlice(context, bb);
    } else {
      await drawNormal(context, bb);
    }
  }
}
