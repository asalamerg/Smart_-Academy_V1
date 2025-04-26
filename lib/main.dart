import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/feature/authentication/view/screen_ui/login/login.dart';
import 'package:smart_academy/feature/authentication/view/screen_ui/register/register.dart';
import 'package:smart_academy/feature/authentication/view_model/auth_bloc.dart';
import 'package:smart_academy/feature/chat/chat_chat/view/chat_screen.dart';
import 'package:smart_academy/feature/chat/chat_chat/view_model/chat_view_model.dart';
import 'package:smart_academy/feature/chat/chat_screen_home.dart';
import 'package:smart_academy/feature/chat/room/view/create_room_screen.dart';
import 'package:smart_academy/feature/chat/room/view_model/view_model_room.dart';

import 'package:smart_academy/feature/home/view/home.dart';
import 'package:smart_academy/firebase_options.dart';
import 'package:smart_academy/shared/bloc_observer.dart';

import 'shared/theme/apptheme.dart';


Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  Bloc.observer=AppBlocObserver();
  runApp( MultiBlocProvider( providers: [
    BlocProvider(create: (_)=>AuthBloc()), 
    BlocProvider(create: (_)=>ViewModelRoom()),
    BlocProvider(create: (_)=>ChatViewModel())
  ]
      ,child:   const SmartAcademy()));
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
      CreateRoomScreen.routeName :(context)=>const CreateRoomScreen(),
      Chat.routeName :(context)=>const  Chat(),
      ChatHome.routeName :(context)=>const ChatHome()

    },initialRoute: Login.routeName,
     theme: AppTheme.light,
     themeMode: ThemeMode.light,
   );
  }
}