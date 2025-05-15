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

class RegisterTeacher extends StatefulWidget {
  static const String routeName = "RegisterTeacher";

  const RegisterTeacher({super.key});

  @override
  State<RegisterTeacher> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterTeacher> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image/background.png"),
              fit: BoxFit.fill),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Register",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextFormField(
                  title: "Name",
                  controller: nameController,
                  validator: validation.name,
                ),
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
                DefaultTextFormField(
                  title: "ID",
                  controller: idController,
                  validator: validation.id,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                BlocListener<AuthBlocTeacher, AuthStatusTeacher>(
                    listener: (_, state) {
                      if (state is RegisterAuthLoadingTeacher) {
                        const Loading();
                      } else if (state is RegisterAuthSuccessTeacher) {
                        Navigator.of(context).pushReplacementNamed(
                          HomeScreenTeacher.routeName,
                        );
                      } else if (state is RegisterAuthErrorTeacher) {
                        Fluttertoast.showToast(
                            msg: state.error,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: DefaultButton(
                      onPressed: registerTeacher,
                      title: "Register",
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerTeacher() {
    BlocProvider.of<AuthBlocTeacher>(context).registerViewModelTeacher(
        name: nameController.text,
        password: passwordController.text,
        numberId: idController.text,
        email: emailController.text);
  }
}
