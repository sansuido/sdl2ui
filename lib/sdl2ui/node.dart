import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'events/internal/event.dart' as ui;
import 'node_context.dart' as ui;
import 'window.dart' as ui;

class Node {
  
  Node? _parent;
  final _children = <Node>[];
  final _eventList = <ui.Event>[];
  Point<double> _position = Point<double>(0, 0);
  Point<double> _contentSize = Point<double>(0, 0);
  Point<double> _anchorPoint = Point<double>(0, 0);
  double _scale = 1.0;

  Node? getParent() {
    return _parent;
  }

  T? getAncestor<T>() {
    Node? node = this;
    while (node != null) {
      if (node is T) {
        return node as T;
      }
      node = node.getParent();
    }
    return null;
  }

  List<Node> getCloneChildren() {
    return [..._children];
  }

  Future addChild(Node child) async {
    child._parent = this;
    _children.add(child);
    await child.ctor();
  }

  Future remove(Node child) async {
    await child.walkDestroy();
    _children.remove(child);
  }

  Future removeAllChildren() async {
    var children = getCloneChildren();
    for (var child in children) {
      await remove(child);
    }
  }

  Future removeFromParent() async {
    if (_parent != null) {
      await _parent!.remove(this);
    }
  }
  
  // local
  double getScale() {
    return _scale;
  }

  void setScale(double scale) {
    _scale = scale;
  }

  Point<double> getPosition() {
    return _position;
  }

  void setPosition(Point<double> position) {
    _position = position;
  }

  Point<double> getContentSize() {
    return _contentSize;
  }

  void setContentSize(Point<double> contentSize) {
    _contentSize = contentSize;
  }

  Point<double> getAnchorPoint() {
    return _anchorPoint;
  }

  void setAnchorPoint(Point<double> anchorPoint) {
    _anchorPoint = anchorPoint;
  }

  // world
  double getWorldScale() {
    var scale = getScale();
    var node = getParent();
    while (node != null) {
      scale *= node.getScale();
      node = node.getParent();
    }
    return scale;
  }

  Point<double> getWorldPosition() {
    var position = getPosition();
    var parent = getParent();
    double scale = 1.0;
    if (parent != null) {
      scale = parent.getWorldScale();
    }
    return Point<double>(position.x * scale, position.y * scale);
  }

  Point<double> getWorldContentSize() {
    var contentSize = getContentSize();
    var scale = getWorldScale();
    return Point(contentSize.x * scale, contentSize.y * scale);
  }

  Point<double> getWorldAnchorPointInPoints() {
    var contentSize = getWorldContentSize();
    return Point<double>(contentSize.x * _anchorPoint.x, contentSize.y * _anchorPoint.y);
  }

  Point<double> convertToWorldSpace([Point<double>? point]) {
    point ??= Point<double>(0, 0);
    Node? node = this;
    while (node != null) {
      var lt = node.getWorldPosition() - node.getWorldAnchorPointInPoints();
      point = point! + lt;
      node = node.getParent();
    }
    return point!;
  }

  Point<double> convertToWorldSpaceAR([Point<double>? point]) {
    point ??= Point<double>(0, 0);
    return convertToWorldSpace(point + getWorldAnchorPointInPoints());
  }

  Point<double> convertToNodeSpace([Point<double>? point]) {
    point ??= Point<double>(0, 0);
    Node? node = this;
    while (node != null) {
      var lt = node.getWorldPosition() - node.getWorldAnchorPointInPoints();
      point = point! - lt;
      node = node.getParent();
    }
    return point!;
  }

  Point<double> convertToNodeSpaceAR([Point<double>? point]) {
    point ??= Point<double>(0, 0);
    return convertToWorldSpace(point - getWorldAnchorPointInPoints());
  }

  Rectangle<double> getWorldBoundingBox([Point<double>? calc]) {
    var worldSpace = convertToWorldSpace();
    var contentSize = getWorldContentSize();
    calc ??= Point<double>(0, 0);
    return Rectangle<double>(worldSpace.x, worldSpace.y, contentSize.x + calc.x, contentSize.y + calc.y);
  }

  Rectangle<double>? getWorldIntersectBox() {
    Rectangle<double>? a = getWorldBoundingBox();
    Node? node = getParent();
    while (node != null) {
      if (node is ui.Window) {
        break;
      }
      if (a == null) {
        break;
      }
      var b = node.getWorldBoundingBox();
      var aPointer = a.calloc();
      var bPointer = b.calloc();
      var resultPointer = calloc<SdlRect>();
      var bl = sdlIntersectRect(aPointer, bPointer, resultPointer) == SDL_TRUE;
      if (bl == true) {
        a = resultPointer.create();
      } else {
        a = null;
      }
      aPointer.callocFree();
      bPointer.callocFree();
      resultPointer.callocFree();
      node = node.getParent();
    }
    return a;
  }

  // event
  void addEvent(ui.Event event, {Node? owner}) {
    owner ??= this;
    var window = getAncestor<ui.Window>();
    if (window != null) {
      window.addEventListener(owner, event);
    }
    _eventList.add(event);
  }

  void removeEvent(ui.Event event, {Node? owner}) {
    owner ??= this;
    var window = getAncestor<ui.Window>();
    if (window != null) {
      window.removeEventListener(owner, event);
    }
    _eventList.remove(event);
  }

  // walk
  Future walkUpdateAndDraw(ui.NodeContext context) async {
    await update(context);
    await draw(context);
    var children = getCloneChildren();
    for (var child in children) {
      await child.walkUpdateAndDraw(context);
    }
    await lateUpdate();
    await lateDraw(context);
  }
  
  Future walkResize() async {
    await resize();
    var children = getCloneChildren();
    for (var child in children) {
      await child.walkResize();
    }
  }

  Future walkDestroy() async {
    await destroy();
    var children = getCloneChildren();
    for (var child in children) {
      await child.walkDestroy();
    }
    _children.clear();
  }

  // overwrite
  Future ctor() async {}
  Future update(ui.NodeContext context) async {}
  Future draw(ui.NodeContext context) async {}
  Future lateUpdate() async {}
  Future lateDraw(ui.NodeContext context) async {}
  Future resize() async {} 
  Future destroy() async {
    // remove stack event
    var eventList = [..._eventList];
    for (var event in eventList) {
      removeEvent(event);
    }
    var window = getAncestor<ui.Window>();
    if (window != null) {
      window.action.removeAllActionsFromTarget(this);
    }
  }
}