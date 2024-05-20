import 'package:ansicolor/ansicolor.dart';

class Pen {
  AnsiPen red = AnsiPen()..red(bold: true);
  AnsiPen redBg = AnsiPen()..red(bg: true);
  AnsiPen greenText = AnsiPen()
    ..green(
      bold: true,
    );
  AnsiPen greenBg = AnsiPen()..green(bg: true);
}
