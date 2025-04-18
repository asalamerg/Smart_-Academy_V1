import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/core/theme/apptheme.dart';
import 'package:smart_academy/feature/authentication/presentation/screen_ui/login/login.dart';

import 'package:smart_academy/feature/authentication/presentation/screen_ui/register/register.dart';
import 'package:smart_academy/feature/authentication/view_model/auth_bloc.dart';
import 'package:smart_academy/feature/chat/presentation/create_room_screen.dart';

import 'package:smart_academy/feature/home/home.dart';
import 'package:smart_academy/firebase_options.dart';


Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(BlocProvider(create:(_)=>AuthBloc(),child:   const SmartAcademy()));
}

class SmartAcademy extends StatelessWidget{
  const SmartAcademy({super.key});

  @override
  Widget build(BuildContext context) {

   return MaterialApp(
     debugShowCheckedModeBanner: false,
    home: const Login(),
    routes: {
      HomeScreen.routeName :(context)=>const HomeScreen(),
      Login.routeName :(context)=>const Login(),
      Register.routeName :(context)=>const Register(),
      CreateRoomScreen.routeName :(context)=>CreateRoomScreen(),
    },initialRoute: HomeScreen.routeName,
     theme: AppTheme.light,
     themeMode: ThemeMode.light,
   );
  }
}