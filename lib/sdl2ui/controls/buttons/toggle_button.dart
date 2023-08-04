import 'dart:math';
import 'button.dart' as ui;
import '../../sprite_frame.dart' as ui;

class ToggleButton extends ui.Button {
  late ui.SpriteFrame offNormal;
  ui.SpriteFrame? offSelected;
  ui.SpriteFrame? onNormal;
  ui.SpriteFrame? onSelected;
  Future Function(ui.Button, bool)? onToggle;
  bool _toggle = false;

  ToggleButton(
      {required this.offNormal,
      this.offSelected,
      this.onNormal,
      this.onSelected,
      this.onToggle,
      double? padding,
      Point<double>? shift})
      : super(
            normal: offNormal,
            selected: offSelected,
            padding: padding,
            shift: shift) {
    onClick = _onClick;
  }

  void setToggle(bool toggle) {
    _toggle = toggle;
    ui.SpriteFrame? normalFrame;
    ui.SpriteFrame? selectedFrame;
    if (_toggle) {
      normalFrame = onNormal;
      selectedFrame = onSelected;
    } else {
      normalFrame = offNormal;
      selectedFrame = offSelected;
    }
    reloadSpriteFrame('normal', normalFrame);
    reloadSpriteFrame('selected', selectedFrame);
  }

  Future _onClick(_) async {
    setToggle(!_toggle);
    if (onToggle != null) {
      await onToggle!(this, _toggle);
    }
  }
}
