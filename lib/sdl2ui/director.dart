import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:sdl2/sdl2gfx.dart' as gfx;

import 'node.dart' as ui;
import 'window.dart' as ui;

class Director extends ui.Node {
  //late TextureManager textureManager;
  //static final Director _instance = Director._internal();
  //factory Director() {
  //  return _instance;
  //}
  //Director._internal() {
  //  textureManager = TextureManager();
  //}
  late gfx.FpsManager fps;

  @override
  Future addChild(ui.Node child) async {
    var window = child as ui.Window;
    await super.addChild(window);
    await window.requestResize();
  }

  Future<bool> init([flags = SDL_INIT_EVERYTHING]) async {
    if (sdlInit(flags) != 0) {
      return false;
    }
    fps = gfx.FpsManager()
      ..init()
      ..setFramerate(60);
    await ctor();
    return true;
  }

  Future run() async {
    var event = calloc<SdlEvent>();
    var running = true;
    while (running) {
      var children = getCloneChildren();
      while (event.poll() != 0) {
        for (var child in children) {
          var window = child as ui.Window;
          await window.handleEvents(event);
        }
      }
      var allWindowsClosed = true;
      for (var child in children) {
        var window = child as ui.Window;
        await window.requestUpdateAndDraw();
        if (window.isAlive()) {
          allWindowsClosed = false;
        } else {
          await remove(window);
        }
      }
      if (allWindowsClosed) {
        break;
      }
      fps.delay();
    }
  }

  void quit() {
    gfx.gfxFree();
    sdlQuit();
  }
}
