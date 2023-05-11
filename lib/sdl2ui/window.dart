import 'dart:ffi';
import 'dart:math';
import 'package:sdl2/sdl2.dart';
import 'events/internal/event.dart' as ui;
import 'events/event_drop_manager.dart' as ui;
import 'internal/ttf_manager.dart' as ui;
import 'node.dart' as ui;
import 'node_context.dart' as ui;
import 'events/internal/event_manager.dart' as ui;
import 'events/event_mouse_manager.dart' as ui;
import 'events/event_keyboard_manager.dart' as ui;
import 'events/event_text_manager.dart' as ui;
import 'internal/image_manager.dart' as ui;
import 'actions/internal/action_manager.dart' as ui;

class Window extends ui.Node {
  bool _shown = false;
  bool _alive = false;
  int _prevTicks = 0;
  late final Pointer<SdlWindow> _window;
  late final Pointer<SdlRenderer> _renderer;
  late final List<Rectangle<double>> _clipRectList;
  late ui.EventMouseManager _eventMouseManager;
  late ui.EventDropManager _eventDropManager;
  late ui.EventKeyboardManager _eventKeyboardManager;
  late ui.EventTextManager _eventTextManager;
  late ui.EventManager event;
  late ui.ImageManager image;
  late ui.TtfManager ttf;
  late ui.ActionManager action;

  Window() {
    _clipRectList = [];
    _eventMouseManager = ui.EventMouseManager();
    _eventDropManager = ui.EventDropManager();
    _eventKeyboardManager = ui.EventKeyboardManager();
    _eventTextManager = ui.EventTextManager();
    action = ui.ActionManager();
  }

  Pointer<SdlWindow> getWindowHandle() => _window;
  Pointer<SdlRenderer> getRendererHandle() => _renderer;
  bool isShown() => _shown;
  bool isAlive() => _alive;
  bool create({
    required String title,
    int? x,
    int? y,
    required int w,
    required int h,
    dynamic flags = 0,
  }) {
    _window =
        SdlWindowEx.create(title: title, x: x, y: y, w: w, h: h, flags: flags);
    if (_window == nullptr) {
      return false;
    }
    _renderer = _window.createRenderer(
        -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (_renderer == nullptr) {
      return false;
    }
    event = ui.EventManager();
    image = ui.ImageManager(_renderer);
    ttf = ui.TtfManager(_renderer);
    var logicalSize = _renderer.getLogicalSize();
    if (logicalSize.x != 0 && logicalSize.y != 0) {
      setContentSize(Point<double>(logicalSize.x, logicalSize.y));
//      setContentSize(logicalSize);
    } else {
      setContentSize(_window.getSize());
//      setContentSize(_window.getSize());
    }
    _shown = true;
    _alive = true;
    return true;
  }

  Future setLogicalSize(Point<double> logicalSize) async {
    _renderer.setLogicalSize(logicalSize.x.toInt(), logicalSize.y.toInt());
    setContentSize(logicalSize);
    await requestResize();
  }

  void addEventListener(ui.Node node, ui.Event event) {
    if (event is ui.EventMouse) {
      _eventMouseManager.addNode(node, event);
    } else if (event is ui.EventDrop) {
      _eventDropManager.addNode(node, event);
    } else if (event is ui.EventKeyboard) {
      _eventKeyboardManager.addNode(node, event);
    } else if (event is ui.EventText) {
      _eventTextManager.addNode(node, event);
    }
  }

  void removeEventListener(ui.Node node, ui.Event event) {
    if (event is ui.EventMouse) {
      _eventMouseManager.removeNode(node);
    } else if (event is ui.EventDrop) {
      _eventDropManager.removeNode(node);
    } else if (event is ui.EventKeyboard) {
      _eventKeyboardManager.removeNode(node);
    } else if (event is ui.EventText) {
      _eventTextManager.removeNode(node);
    }
  }

  Future handleEvents(Pointer<SdlEvent> event) async {
    switch (event.type) {
      case SDL_KEYDOWN:
      case SDL_KEYUP:
        if (event.key.ref.windowId == _window.getId()) {
          await _eventKeyboardManager.handleEvents(event);
        }
        break;
      case SDL_MOUSEBUTTONDOWN:
      case SDL_MOUSEBUTTONUP:
      case SDL_MOUSEMOTION:
      case SDL_MOUSEWHEEL:
        await _eventMouseManager.handleEvents(event);
        break;
      case SDL_DROPFILE:
        if (event.drop.ref.windowId == _window.getId()) {
          await _eventDropManager.handleEvents(event);
          sdlFree(event.drop.ref.file);
        }
        break;
      case SDL_TEXTINPUT:
        if (event.text.ref.windowId == _window.getId()) {
          await _eventTextManager.handleEvents(event);
        }
        break;
      case SDL_TEXTEDITING:
        if (event.edit.ref.windowId == _window.getId()) {
          await _eventTextManager.handleEvents(event);
        }
        break;
      case SDL_TEXTEDITING_EXT:
        if (event.editExt.ref.windowId == _window.getId()) {
          await _eventTextManager.handleEvents(event);
        }
        break;

      case SDL_WINDOWEVENT:
        if (event.window.ref.windowId == _window.getId()) {
          switch (event.window.ref.event) {
            case SDL_WINDOWEVENT_SHOWN:
              _shown = true;
              break;
            case SDL_WINDOWEVENT_HIDDEN:
              _shown = false;
              break;
            case SDL_WINDOWEVENT_RESIZED:
              var logicalSize = _renderer.getLogicalSize();
              if (logicalSize.x != 0 && logicalSize.y != 0) {
                setContentSize(Point<double>(
                    logicalSize.x.toDouble(), logicalSize.y.toDouble()));
              } else {
                setContentSize(Point<double>(event.window.ref.data1.toDouble(),
                    event.window.ref.data2.toDouble()));
              }
              await requestResize();
              break;
            case SDL_WINDOWEVENT_CLOSE:
              _window.hide();
              _alive = false;
              break;
          }
        }
        break;
    }
  }

  void pushClipRect(Rectangle<double> rect) {
    var rectPointer = rect.calloc();
    sdlRenderSetClipRect(_renderer, rectPointer);
    rectPointer.callocFree();
    _clipRectList.add(rect);
  }

  Rectangle<double>? popClipRect() {
    Rectangle<double>? result;
    if (_clipRectList.isNotEmpty) {
      result = _clipRectList.last;
      _clipRectList.removeLast();
    }
    if (_clipRectList.isNotEmpty) {
      var rectPointer = _clipRectList.last.calloc();
      sdlRenderSetClipRect(_renderer, rectPointer);
      rectPointer.callocFree();
    } else {
      sdlRenderSetClipRect(_renderer, nullptr);
    }
    return result;
  }

  ui.NodeContext createContext() {
    var ticks = sdlGetTicks();
    var context = ui.NodeContext();
    context.renderer = _renderer;
    context.window = this;
    context.dt = _prevTicks > 0 ? (ticks - _prevTicks) / 1000 : 0;
    _prevTicks = ticks;
    return context;
  }

  Future requestResize() async {
    await walkResize();
  }

  Future requestUpdateAndDraw() async {
    _clipRectList.clear();
    _renderer
      ..setDrawColor(255, 255, 255, 255)
      ..clear();
    await walkUpdateAndDraw(createContext());
    _renderer.present();
  }

  @override
  Future update(ui.NodeContext context) async {
    await super.update(context);
    action.update(context.dt);
  }

  @override
  Future destroy() async {
    await super.destroy();
    image.destroy();
    ttf.destroy();
    _renderer.destroy();
    _window.destroy();
  }
}
