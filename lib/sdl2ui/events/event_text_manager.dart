import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';

import '../node.dart' as ui;
import 'internal/event.dart' as ui;
import 'internal/event_manager.dart' as ui;

class EventText extends ui.Event<EventTextManager> {
  void setTextInput(Future<bool> Function(EventTextManager, ui.Node) function) {
    list['onTextInput'] = function;
  }

  void setTextEditing(
      Future<bool> Function(EventTextManager, ui.Node) function) {
    list['onTextEditing'] = function;
  }
}

class EventTextManager extends ui.EventManager<EventText> {
  String text = '';
  int start = 0;
  int length = 0;

  void _loadFromSdlTextInputEvent(Pointer<SdlTextInputEvent> event) {
    text = event.text;
    start = 0;
    length = 0;
  }

  void _loadFromSdlTextEditingEvent(Pointer<SdlTextEditingEvent> event) {
    text = event.text;
    start = event.ref.start;
    length = event.ref.length;
  }

  void _loadFromSdlTextEditingExtEvent(Pointer<SdlTextEditingExtEvent> event) {
    text = event.ref.text.cast<Utf8>().toDartString();
    start = event.ref.start;
    length = event.ref.length;
  }

  @override
  Future handleEvents(Pointer<SdlEvent> event) async {
    await super.handleEvents(event);
    switch (event.type) {
      case SDL_TEXTINPUT:
        _loadFromSdlTextInputEvent(event.text);
        await callEventName('onTextInput');
        break;
      case SDL_TEXTEDITING:
        _loadFromSdlTextEditingEvent(event.edit);
        await callEventName('onTextEditing');
        break;
      case SDL_TEXTEDITING_EXT:
        _loadFromSdlTextEditingExtEvent(event.editExt);
        await callEventName('onTextEditing');
        break;
      default:
        break;
    }
  }
}
