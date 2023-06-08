import '../../node.dart' as ui;
import 'event_manager.dart' as ui;

class Event<T extends ui.EventManager> {
  var list = <String, Future<bool> Function(T, ui.Node)>{};

  Future<bool> Function(T, ui.Node)? getFunction(String name) {
    return list[name];
  }

  Future<bool> call(String name, T manager, ui.Node node) async {
    var bl = false;
    var function = getFunction(name);
    if (function != null) {
      bl = await function(manager, node);
    }
    return bl;
  }
}
