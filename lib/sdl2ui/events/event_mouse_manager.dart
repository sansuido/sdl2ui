import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';

import '../node.dart' as ui;
import 'internal/event.dart' as ui;
import 'internal/event_manager.dart' as ui;

class EventMouse extends ui.Event<EventMouseManager> {
  void setMouseDown(
      Future<bool> Function(EventMouseManager, ui.Node) function) {
    list['onMouseDown'] = function;
  }

  void setMouseUp(Future<bool> Function(EventMouseManager, ui.Node) function) {
    list['onMouseUp'] = function;
  }

  void setMouseMove(
      Future<bool> Function(EventMouseManager, ui.Node) function) {
    list['onMouseMove'] = function;
  }

  void setScroll(Future<bool> Function(EventMouseManager, ui.Node) function) {
    list['onScroll'] = function;
  }
}

class EventMouseManager extends ui.EventManager<EventMouse> {
  late int which;
  late int button;
  late int pressed;
  late int state = 0;
  late int clicks = 0;
  late Point<double> position;
  late Point<double> rel;
  late int direction;
  late Point<double> precise;

  EventMouseManager() {
    clear();
  }

  void clear() {
    which = 0;
    button = 0;
    state = 0;
    clicks = 0;
    position = Point<double>(0, 0);
    rel = Point<double>(0, 0);
    direction = 0;
    precise = Point<double>(0, 0);
  }

  void _loadFromSdlMouseButtonEvent(Pointer<SdlMouseButtonEvent> event) {
    clear();
    which = event.ref.which;
    button = event.ref.button;
    pressed = event.ref.state;
    state = sdlGetMouseState(nullptr, nullptr);
    clicks = event.ref.clicks;
    position = Point(event.ref.x.toDouble(), event.ref.y.toDouble());
  }

  void _loadFromSdlMouseMotionEvent(Pointer<SdlMouseMotionEvent> event) {
    clear();
    which = event.ref.which;
    state = event.ref.state;
    position = Point(event.ref.x.toDouble(), event.ref.y.toDouble());
    rel = Point(event.ref.xrel.toDouble(), event.ref.yrel.toDouble());
  }

  void _loadFromSdlMouseWheelEvent(Pointer<SdlMouseWheelEvent> event) {
    clear();
    which = event.ref.which;
    state = sdlGetMouseState(nullptr, nullptr);
    var xPointer = calloc<Int32>();
    var yPointer = calloc<Int32>();
    sdlGetMouseState(xPointer, yPointer);
    position = Point(xPointer.value.toDouble(), yPointer.value.toDouble());
    xPointer.callocFree();
    yPointer.callocFree();
    rel = Point(event.ref.x.toDouble(), event.ref.y.toDouble());
    precise = Point(event.ref.preciseX, event.ref.preciseY);
  }

  @override
  Future handleEvents(Pointer<SdlEvent> event) async {
    await super.handleEvents(event);
    switch (event.type) {
      case SDL_MOUSEBUTTONUP:
      case SDL_MOUSEBUTTONDOWN:
        _loadFromSdlMouseButtonEvent(event.button);
        var name = '';
        if (event.type == SDL_MOUSEBUTTONUP) {
          name = 'onMouseUp';
        } else {
          name = 'onMouseDown';
        }
        await callEventName(name);
        break;
      case SDL_MOUSEMOTION:
        _loadFromSdlMouseMotionEvent(event.motion);
        await callEventName('onMouseMove');
        break;
      case SDL_MOUSEWHEEL:
        _loadFromSdlMouseWheelEvent(event.wheel);
        await callEventName('onScroll');
        break;
    }
  }
}
