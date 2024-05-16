import 'package:ansicolor/ansicolor.dart';

class Pen {
  AnsiPen red = AnsiPen()..red(bold: true);
  AnsiPen greenText = AnsiPen()
    ..green(
      bold: true,
    );
  AnsiPen greenBg = AnsiPen()..green(bg: true);
}
