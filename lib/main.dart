import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_academy/firebase_options.dart';
import 'package:smart_academy/shared/bloc_observer.dart';
import 'package:smart_academy/student/feature/chat/room/view/room_screen.dart';

import 'parent/feature_parent/authentication_parent/login_parent.dart';
import 'parent/feature_parent/authentication_parent/register_parent.dart';
import 'shared/widget/select _category.dart';
import 'shared/theme/apptheme.dart';
import 'student/feature/authentication/view/screen_ui/login/login.dart';
import 'student/feature/authentication/view/screen_ui/register/register.dart';
import 'student/feature/authentication/view_model/auth_bloc.dart';
import 'student/feature/chat/chat_chat/view_model/chat_view_model.dart';
import 'student/feature/chat/chat_screen_home.dart';
import 'student/feature/chat/room/view/create_room_screen.dart';
import 'student/feature/chat/room/view_model/view_model_room.dart';
import 'student/feature/home/view/home.dart';
import 'teacher/feature_teacher/authentication_teacher/view/login_teacher.dart';
import 'teacher/feature_teacher/authentication_teacher/view/register_teacher.dart';


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
      ChatHome.routeName :(context)=>const ChatHome(),
      SelectCategory.routeName : (context)=>const SelectCategory(),
      LoginTeacher.routeName :(context)=>const LoginTeacher(),
      LoginParent.routeName :(context)=>const LoginParent(),
      RegisterParent.routeName :(context)=>const RegisterParent(),
      RegisterTeacher.routeName :(context)=>const RegisterTeacher(),

    },initialRoute: SelectCategory.routeName,

     theme: AppTheme.light,
     themeMode: ThemeMode.light,
   );
  }
}