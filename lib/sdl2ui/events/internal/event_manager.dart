import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import '../../node.dart' as ui;
import 'event.dart' as ui;

class EventManager<T> {

  final list = <ui.Node, T>{};
  int type = 0;

  static ui.Node? _capture;

  ui.Node? getCapture() {
    return _capture;
  }

  T? getEvent(ui.Node node) {
    return list[node];
  }

  void setCapture(ui.Node node) {
    _capture = node;
  }

  bool isCapture(ui.Node node) {
    return _capture == node;
  }

  void removeCapture() {
    _capture = null;
  }

  void addNode(ui.Node node, T event) {
    list[node] = event;
  }

  void removeNode(ui.Node node) {
    list.remove(node);
  }

  Future handleEvents(Pointer<SdlEvent> event) async {
    type = event.type;
  }

  void startTextInput() {
    sdlStartTextInput();
  }

  void setTextInputPosition(Point<double> pos) {
    var rectPointer = calloc<SdlRect>()
      ..ref.x = pos.x.toInt()
      ..ref.y = pos.y.toInt();
    sdlSetTextInputRect(rectPointer);
    rectPointer.callocFree();
  }

  void stopTextInput() {
    sdlStopTextInput();
  }

  Future callEventName(String eventName) async {
    var capture = getCapture();
    if (capture != null && list[capture] != null) {
      var event = list[capture]! as ui.Event;
      var bl = await event.call(eventName, this, capture);
      if (bl) {
        return;
      }
    }
    for (var entry in list.entries) {
      var event = entry.value  as ui.Event;
      var bl = await event.call(eventName, this, entry.key);
      if (bl) {
        return;
      }
    }
  }
}