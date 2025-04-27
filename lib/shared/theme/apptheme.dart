

import 'package:flutter/material.dart';

class AppTheme{
  static const Color primary=Color(0XFFA9ECE4);
 static const   Color blu=Color(0xff1495b7);

 static ThemeData light =ThemeData(
   scaffoldBackgroundColor: Colors.transparent,
   appBarTheme: const AppBarTheme( backgroundColor: Colors.transparent ,),
    textTheme: const TextTheme(displayLarge:TextStyle(color: Colors.white , fontFamily: "Kavoon", fontSize: 40,) ,

      displaySmall: TextStyle(color: Colors.black , fontSize: 18, fontWeight: FontWeight.bold),
      
    ),


  );
}