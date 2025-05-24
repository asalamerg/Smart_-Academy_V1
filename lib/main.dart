import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view/login_admin.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view/register_admin.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view_model/auth_bloc_admin.dart';
import 'package:smart_academy/admin/feature_admin/screen_home_admin/view/screen_home_admin.dart';
import 'package:smart_academy/firebase_options.dart';
import 'package:smart_academy/shared/bloc_observer.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view_model/auth_bloc_teacher.dart';

import 'parent/feature_parent/authentication_parent/view/login_parent.dart';
import 'parent/feature_parent/authentication_parent/view/register_parent.dart';
import 'parent/feature_parent/authentication_parent/view_model/bloc_auth_parent.dart';
import 'parent/feature_parent/screen_home_parent/view/screen_home_parent.dart';
import 'shared/widget/select _category.dart';
import 'shared/theme/apptheme.dart';
import 'student/feature/authentication/view/screen_ui/login/login.dart';
import 'student/feature/authentication/view/screen_ui/register/register.dart';
import 'student/feature/authentication/view_model/auth_bloc.dart';

import 'student/feature/home/view/home.dart';
import 'teacher/feature_teacher/authentication_teacher/view/login_teacher.dart';
import 'teacher/feature_teacher/authentication_teacher/view/register_teacher.dart';
import 'teacher/feature_teacher/screen_home_teacher/view/screen_home_teacher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => RoomViewModel()),
    BlocProvider(create: (_) => AuthBloc()),
    BlocProvider(create: (_) => AuthBlocTeacher()),
    BlocProvider(create: (_) => AuthBlocAdmin()),
    BlocProvider(create: (_) => AuthBlocParent()),
    BlocProvider(create: (_) => MessageViewModel()),
  ], child: const SmartAcademy()));
}

class SmartAcademy extends StatelessWidget {
  const SmartAcademy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        Login.routeName: (context) => const Login(),
        Register.routeName: (context) => const Register(),
        MainChatScreen.routeName: (_) => const MainChatScreen(),
        CreateRoomScreen.routeName: (_) => const CreateRoomScreen(),
        SelectCategory.routeName: (context) => const SelectCategory(),
        LoginTeacher.routeName: (context) => const LoginTeacher(),
        LoginParent.routeName: (context) => const LoginParent(),
        RegisterParent.routeName: (context) => const RegisterParent(),
        RegisterTeacher.routeName: (context) => const RegisterTeacher(),
        LoginAdmin.routeName: (context) => const LoginAdmin(),
        RegisterAdmin.routeName: (context) => const RegisterAdmin(),
        HomeScreenTeacher.routeName: (context) => const HomeScreenTeacher(),
        ScreenHomeAdmin.routeName: (context) => const ScreenHomeAdmin(),
        ScreenHomeParent.routeName: (context) => const ScreenHomeParent(),
        ChatScreen.routeName: (_) => const ChatScreen(),
      },
      initialRoute: SelectCategory.routeName,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
    );
  }
}
