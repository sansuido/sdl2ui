import 'dart:ffi';
import 'package:sdl2/sdl2.dart';

import 'window.dart' as ui;

class NodeContext {
  late ui.Window window;
  late Pointer<SdlRenderer> renderer;
  late double dt;
}
