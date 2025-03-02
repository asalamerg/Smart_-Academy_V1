
import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme{
  static const Color primary=Color(0XFFA9ECE4);

 static ThemeData light =ThemeData(
   scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
    textTheme: TextTheme(displayLarge:TextStyle(color: Colors.white , fontFamily: "Kavoon", fontSize: 40,) ,
      displaySmall: TextStyle(color: Colors.black , fontSize: 25, fontWeight: FontWeight.bold),
    )
  );
}