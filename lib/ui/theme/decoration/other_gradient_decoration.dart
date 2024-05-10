import 'package:flutter/material.dart';

class OtherGradientDecoration extends BoxDecoration {
  const OtherGradientDecoration()
      : super(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF560D4E),
                Color(0xFF57064F),
                Color(0xFF47105D),
                Color(0xFF361C56),
                Color(0xFF323654)
              ]),
        );
}
