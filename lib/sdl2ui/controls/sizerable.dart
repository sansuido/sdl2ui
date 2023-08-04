import '../node.dart' as ui;

mixin Sizable on ui.Node {
  double szWidth = -1;
  double szHeight = -1;
  double szFactor = 1;
  double szAlign = 0.5;
  double szBorder = 5;
}
