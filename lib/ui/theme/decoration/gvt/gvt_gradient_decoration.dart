import 'package:flutter/material.dart';

class GvtGradientDecoration extends BoxDecoration {
  const GvtGradientDecoration({borderRadius})
      : super(
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF0d3171),
                Color(0xFF2a3171),
                Color(0xFF3c3170),
                Color(0xFF4a326f),
                Color(0xFF56326d),
                Color(0xFF4e3a75),
                Color(0xFF44417b),
                Color(0xFF3a4880),
                Color(0xFF005483),
                Color(0xFF005c7c),
                Color(0xFF00626f),
                Color(0xFF0c6660),
              ],
            ),
            borderRadius: borderRadius);
}
//background-image: linear-gradient(to right top, #0d3171, #2a3171, #3c3170, #4a326f, #56326d, #4e3a75, #44417b, #3a4880, #005483, #005c7c, #00626f, #0c6660);
