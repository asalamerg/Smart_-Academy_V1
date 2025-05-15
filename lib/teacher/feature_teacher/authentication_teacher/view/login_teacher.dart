import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_academy/shared/loading/loading.dart';
import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view_model/auth_bloc_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view_model/auth_teacher_state.dart';
import 'package:smart_academy/teacher/feature_teacher/screen_home_teacher/view/screen_home_teacher.dart';

import 'register_teacher.dart';

class LoginTeacher extends StatefulWidget {
  static const String routeName = "LoginTeacher";

  const LoginTeacher({super.key});

  @override
  State<LoginTeacher> createState() => _LoginState();
}

class _LoginState extends State<LoginTeacher> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Login",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextFormField(
                  title: "Email",
                  controller: emailController,
                  validator: validation.email,
                ),
                DefaultTextFormField(
                  title: "Password",
                  controller: passwordController,
                  validator: validation.password,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(RegisterTeacher.routeName);
                  },
                  child: Text(
                    "Create an account",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                const SizedBox(height: 30),
                BlocListener<AuthBlocTeacher, AuthStatusTeacher>(
                  listener: (_, state) {
                    if (state is LoginAuthLoadingTeacher) {
                      // هنا نعرض الـ Loading عند تحميل التحقق
                      showDialog(
                        context: context,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is LoginAuthSuccessTeacher) {
                      Navigator.of(context)
                          .pushReplacementNamed(HomeScreenTeacher.routeName);
                    } else if (state is LoginAuthErrorTeacher) {
                      Navigator.of(context)
                          .pop(); // إغلاق الـ Loading عند وجود خطأ
                      Fluttertoast.showToast(
                        msg: state.error,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: DefaultButton(
                    onPressed: loginTeacher,
                    title: "Login",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginTeacher() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBlocTeacher>(context).loginViewModelTeacher(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }
}
