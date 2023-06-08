import 'dart:ffi';

import 'package:sdl2/sdl2.dart';

import '../node.dart' as ui;
import 'internal/event.dart' as ui;
import 'internal/event_manager.dart' as ui;

class EventKeyboard extends ui.Event<EventKeyboardManager> {
  void setKeyDown(
      Future<bool> Function(EventKeyboardManager, ui.Node) function) {
    list['onKeyDown'] = function;
  }

  void setKeyUp(Future<bool> Function(EventKeyboardManager, ui.Node) function) {
    list['onKeyUp'] = function;
  }
}

class EventKeyboardManager extends ui.EventManager<EventKeyboard> {
  int sym = 0;
  int mod = 0;
  int scancode = 0;

  void _loadFromSdlKeyboardEvent(Pointer<SdlKeyboardEvent> event) {
    sym = event.keysym.ref.sym;
    mod = event.keysym.ref.mod;
    scancode = event.keysym.ref.scancode;
  }

  @override
  Future handleEvents(Pointer<SdlEvent> event) async {
    await super.handleEvents(event);
    switch (event.type) {
      case SDL_KEYDOWN:
      case SDL_KEYUP:
        var name = '';
        _loadFromSdlKeyboardEvent(event.key);
        if (event.type == SDL_KEYDOWN) {
          name = 'onKeyDown';
        } else {
          name = 'onKeyUp';
        }
        if (name != '') {
          await callEventName(name);
        }
        break;
    }
  }
}
