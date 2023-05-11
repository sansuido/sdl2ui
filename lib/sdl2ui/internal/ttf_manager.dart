import 'dart:ffi';
import 'package:sdl2/sdl2.dart';

class TtfStatus {
  late int height;
  late int ascent;
  late int descent;
  late int lineSkip;
  late int fontFaces;
  late int faceIsFixedWidth;
  late String faceFamilyName;
  late String faceStyleName;
  TtfStatus(Pointer<TtfFont> font) {
    height = font.height();
    ascent = font.ascent();
    descent = font.descent();
    lineSkip = font.lineSkip();
    fontFaces = font.faces();
    faceIsFixedWidth = font.faceIsFixedWidth();
    faceFamilyName = font.faceFamilyName()!;
    faceStyleName = font.faceStyleName()!;
  }
}

class TtfManager {

  late Pointer<SdlRenderer> renderer;
  var list = <String, Pointer<SdlTexture>>{};
  var _defaultFontFile = '';
  var _defaultFontSize = 24;
  var _defaultTextColor = SdlColorEx.rgbaToU32(0, 0, 0, 255);
  int? _defaultBackgroundColor;
  var _defaultStyle = TTF_STYLE_NORMAL;
  var _defaultOutline = 0;

  TtfManager(this.renderer);

  String _createKey(String fontFile, int fontSize, int textColor, int? backgroundColor, int style, int outline, String text) {
    return '$fontFile:$fontSize:$textColor:$backgroundColor:$style:$outline:$text';
  }

  void setDefaultFontFile(String defaultFontFile) {
    _defaultFontFile = defaultFontFile;
  }

  void setDefaultFontSize(int defaultFontSize) {
    _defaultFontSize = defaultFontSize;
  }

  void setDefaultTextColor(int defaultTextColor) {
    _defaultTextColor = defaultTextColor;
  }

  void setDefaultStyle(int defaultStyle) {
    _defaultStyle = defaultStyle;
  }

  void setDefaultOutline(int defaultOutline) {
    _defaultOutline = defaultOutline;
  }

  TtfStatus? getStatus({String? fontFile, int? fontSize}) {
    TtfStatus? ttfStatus;
    fontFile ??= _defaultFontFile;
    fontSize ??= _defaultFontSize;
    var font = TtfFontEx.open(fontFile, fontSize);
    if (font != nullptr) {
      ttfStatus = TtfStatus(font);
      font.close();
    }
    return ttfStatus;
  }

  Pointer<SdlTexture> loadTexture(
    String text, {
    String? fontFile,
    int? fontSize,
    int? textColor,
    int? backgroundColor,
    int? style,
    int? outline,
  }) {
    fontFile ??= _defaultFontFile;
    fontSize ??= _defaultFontSize;
    textColor ??= _defaultTextColor;
    backgroundColor ??= _defaultBackgroundColor;
    style ??= _defaultStyle;
    outline ??= _defaultOutline;

    Pointer<SdlTexture> result = nullptr;
    var key = _createKey(fontFile, fontSize, textColor, backgroundColor, style, outline, text);
    if (list[key] != null) {
      result = list[key]!;
    } else {
      var font = TtfFontEx.open(fontFile, fontSize);
      if (font != nullptr) {
        font.setStyle(style);
        font.setOutline(outline);
        Pointer<SdlSurface> surface = nullptr;
        if (backgroundColor != null) {
          surface = font.renderUtf8Shaded(text, textColor, backgroundColor);
        } else {
          surface = font.renderUtf8Blended(text, textColor);
        }
        if (surface != nullptr) {
          var texture = renderer.createTextureFromSurface(surface);
          if (texture != nullptr) {
            result = texture;
            list[key] = texture;
          }
        }
        font.close();
      }
    }
    return result;
  }

  void destroy() {
    list.forEach((key, texture) {
      texture.destroy();
    });
    list.clear();
  }
}
