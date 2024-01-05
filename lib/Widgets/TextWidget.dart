import 'package:flutter/material.dart';

import 'constants.dart';

Widget textwidget(String text, Color color, VoidCallback onTap,
        {double size = 14}) =>
    Builder(builder: (context) {
      return InkWell(
        onTap: onTap,
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: size),
        ),
      );
    });

Widget textwidget1(String text, Color color, VoidCallback onTap,
        {double size = 14}) =>
    Builder(builder: (context) {
      return InkWell(
        onTap: onTap,
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
              fontFamily: "poppins",
              color: color,
              fontWeight: FontWeight.w400,
              fontSize: size),
        ),
      );
    });

Decoration boxdecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: barcolor,
);

// Widget textt(
//   String text,
//   Color colors,

// ) {
//   return Text(text,
//       style: TextStyle(
//         color: colors,
//         fontSize: size
//       ));
// }
