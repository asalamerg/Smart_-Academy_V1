import 'package:flutter/material.dart';
import 'package:smart_academy/core/theme/apptheme.dart';
import 'package:smart_academy/feature/authentication/login/login.dart';
import 'package:smart_academy/feature/authentication/register/register.dart';
import 'package:smart_academy/feature/home/home.dart';

void main() {
  runApp( const SmartAcademy());
}

class SmartAcademy extends StatelessWidget{
  const SmartAcademy({super.key});

  @override
  Widget build(BuildContext context) {

   return MaterialApp(
     debugShowCheckedModeBanner: false,
    routes: {
      HomeScreen.routeName :(context)=>const HomeScreen(),
      Login.routeName :(context)=>Login(),
      Register.routeName :(context)=>Register(),
    },initialRoute: Login.routeName,
     theme: AppTheme.light,
     themeMode: ThemeMode.light,
   );
  }
}