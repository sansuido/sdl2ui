import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:archive/archive.dart';

class ImageManager {

  late Pointer<SdlRenderer> renderer;

  ImageManager(this.renderer);
  
  var list = <String, Pointer<SdlTexture>>{};

  Pointer<SdlTexture> loadTexture(String filename, {Archive? archive}) {
    if (list.containsKey(filename)) {
      return list[filename]!;
    }
    if (archive != null) {
      var file = archive.findFile(filename);
      if (file != null) {
        var content = file.content as List<int>;
        var contentPointer = calloc<Uint8>(content.length);
        for (var i = 0; i < content.length; i++) {
          contentPointer[i] = content[i];
        }
        var rwops = sdlRwFromMem(contentPointer, content.length);
        var texture = imgLoadTextureRw(renderer, rwops, 0);
        contentPointer.callocFree();
        list[filename] = texture;
        return texture;
      }
    }
    var texture = renderer.loadTexture(filename);
    list[filename] = texture;
    return texture;
  }

  void destroy() {
    list.forEach((file, texture) {
      texture.destroy();
    });
    list.clear();
  }
}