import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view_model/auth_admin_state.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view_model/auth_bloc_admin.dart';
import 'package:smart_academy/admin/feature_admin/screen_home_admin/view/screen_home_admin.dart';
import 'package:smart_academy/shared/loading/loading.dart';

import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';




class RegisterAdmin extends StatefulWidget{
  static const String routeName="RegisterAdmin";

  const RegisterAdmin({super.key});

  @override
  State<RegisterAdmin> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterAdmin> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(
              "assets/image/background.png"), fit: BoxFit.fill),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text("Register", style: Theme
              .of(context)
              .textTheme
              .displayLarge,), centerTitle: true,),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextFormField(title: "Name",
                  controller: nameController,
                  validator: validation.name,),
                DefaultTextFormField(title: "Email",
                  controller: emailController,
                  validator: validation.email,),
                DefaultTextFormField(title: "Password",
                  controller: passwordController,
                  validator: validation.password,),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.10,),


                BlocListener<AuthBlocAdmin, AuthStatusAdmin>(
                    listener: (_, state) {
                      if (state is RegisterAuthErrorAdmin) {
                        const Loading();
                      }
                      else if (state is RegisterAuthSuccessAdmin) {
                        Navigator.of(context).pushReplacementNamed(
                            ScreenHomeAdmin.routeName);
                      }
                      else if (state is RegisterAuthErrorAdmin) {
                        Fluttertoast.showToast(
                            msg: state.error,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    },
                    child: DefaultButton(
                      onPressed: registerAdmin, title: "Register",)


                )
              ],),
          ),
        ),
      ),
    );
  }

  void registerAdmin() {
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBlocAdmin>(context).registerViewModelAdmin(
          name: nameController.text,
          password: passwordController.text,
          email: emailController.text);
    }
  }
}
