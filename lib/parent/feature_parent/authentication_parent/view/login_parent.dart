import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/auth_parent_state.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/bloc_auth_parent.dart';
import 'package:smart_academy/parent/feature_parent/screen_home_parent/view/screen_home_parent.dart';
import 'package:smart_academy/shared/loading/loading.dart';
import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';

import 'register_parent.dart';

class LoginParent extends StatefulWidget {
  static const String routeName = "LoginParent";

  const LoginParent({super.key});

  @override
  State<LoginParent> createState() => _LoginState();
}

class _LoginState extends State<LoginParent> {
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
              fit: BoxFit.fill),
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
                    validator: validation.password),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(RegisterParent.routeName);
                    },
                    child: Text(
                      "Create an account",
                      style: Theme.of(context).textTheme.displaySmall,
                    )),
                const SizedBox(height: 30),
                BlocListener<AuthBlocParent, AuthStatusParent>(
                  listener: (_, state) {
                    if (state is LoginAuthLoadingParent) {
                      const Loading();
                    } else if (state is LoginAuthSuccessParent) {
                      Navigator.of(context)
                          .pushReplacementNamed(ScreenHomeParent.routeName);
                    } else if (state is LoginAuthErrorParent) {
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
                    onPressed: loginParent,
                    title: "Login",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginParent() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBlocParent>(context).loginViewModelParent(
          email: emailController.text,
          password: passwordController.text,
          studentId: '');
    }
  }
}
