import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'internal/event.dart' as ui;
import '../node.dart' as ui;
import 'internal/event_manager.dart' as ui;

class EventDrop extends ui.Event<EventDropManager> {
  Future setDrop(
      Future<bool> Function(EventDropManager, ui.Node) function) async {
    list['onDrop'] = function;
  }
}

class EventDropManager extends ui.EventManager<EventDrop> {
  String file = '';

  @override
  Future handleEvents(Pointer<SdlEvent> event) async {
    await super.handleEvents(event);
    file = event.drop.ref.file.cast<Utf8>().toDartString();
    await callEventName('onDrop');
  }
}
