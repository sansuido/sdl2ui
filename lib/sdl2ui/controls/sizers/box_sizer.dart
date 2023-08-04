import 'dart:math';
import './sizer.dart' as ui;
import '../control.dart' as ui;

class BoxSizer extends ui.Sizer {
  bool horizontal;
  double padding;
  BoxSizer({this.horizontal = false, this.padding = 0}) {
    szBorder = 0;
  }

  @override
  Future resize() async {
    await super.resize();
    // copy from parent.getContentSize
    if (getParent()! is! ui.Sizer) {
      setPositionAR(Point<double>(0, 0));
      setContentSize(getParent()!.getContentSize());
    }
    setContentSize(getContentSize() - Point<double>(padding * 2, padding * 2));
    setPositionAR(getPositionAR() + Point<double>(padding, padding));
    double autoFactor = 0;
    double autoSize = horizontal ? getContentSize().x : getContentSize().y;
    var children = getCloneChildren();
    for (var child in children) {
      if (child is ui.Control) {
        var szSize = horizontal ? child.szWidth : child.szHeight;
        if (szSize == -1) {
          autoFactor += child.szFactor;
        } else {
          autoSize -= szSize;
          autoSize -= child.szBorder * 2;
        }
      } else {
        autoSize -=
            horizontal ? child.getContentSize().x : child.getContentSize().y;
      }
    }
    double factorSize = (autoSize / autoFactor.toDouble()).roundToDouble();
    double primaryPosition = 0;
    for (var child in children) {
      double border = 0;
      double replicaContentSize =
          horizontal ? getContentSize().y : getContentSize().x;
      double replicaSize = replicaContentSize;
      double replicaPosition = 0;
      double align = 0.5;
      if (child is ui.Control) {
        align = child.szAlign;
        border = child.szBorder;
        var primarySize = horizontal ? child.szWidth : child.szHeight;
        replicaSize = horizontal ? child.szHeight : child.szWidth;
        if (replicaSize == -1) {
          replicaSize = replicaContentSize;
        } else {
          replicaSize += border * 2;
        }
        if (primarySize == -1) {
          primarySize = factorSize * child.szFactor;
        } else {
          primarySize += border * 2;
        }
        if (horizontal) {
          child.setContentSize(Point<double>(primarySize, replicaSize) -
              Point<double>(border * 2, border * 2));
        } else {
          child.setContentSize(Point<double>(replicaSize, primarySize) -
              Point<double>(border * 2, border * 2));
        }
      }
      if (replicaContentSize != replicaSize) {
        // positional align
        replicaPosition =
            ((replicaContentSize - replicaSize) * align).roundToDouble();
      }
      if (horizontal) {
        child.setPositionAR(Point<double>(primaryPosition, replicaPosition) +
            Point<double>(border, border));
      } else {
        child.setPositionAR(Point<double>(replicaPosition, primaryPosition) +
            Point<double>(border, border));
      }
      primaryPosition += border * 2;
      primaryPosition +=
          horizontal ? child.getContentSize().x : child.getContentSize().y;
    }
  }
}
