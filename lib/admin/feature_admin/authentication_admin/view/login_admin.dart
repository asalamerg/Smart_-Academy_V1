


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

import 'register_admin.dart';



class LoginAdmin extends StatefulWidget{
  static const  String routeName="LoginAdmin";

  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginState();
}

class _LoginState extends State<LoginAdmin> {
  TextEditingController  passwordController =TextEditingController();
  TextEditingController  emailController =TextEditingController();
  var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(backgroundColor: Colors.transparent ,title: Text("Login",style: Theme.of(context).textTheme.displayLarge,),centerTitle: true,),

          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                DefaultTextFormField(title: "Email",controller: emailController, validator: validation.email,),
                DefaultTextFormField(title: "Password",controller: passwordController,validator: validation.password ),


                SizedBox(height: MediaQuery.of(context).size.height * 0.20,),


                InkWell(
                    onTap: (){Navigator.of(context).pushNamed(RegisterAdmin.routeName);},
                    child: Text("Create an account",style: Theme.of(context).textTheme.displaySmall,)),

                const SizedBox(height:30),


            BlocListener<AuthBlocAdmin,AuthStatusAdmin>( listener: (_,state){
              if(state is LoginAuthLoadingAdmin){
                const Loading();
              }
              else if (state is LoginAuthSuccessAdmin){
                Navigator.of(context).pushReplacementNamed(ScreenHomeAdmin.routeName);
              }
              else if (state is LoginAuthErrorAdmin){
                Fluttertoast.showToast(
                    msg:state.error ,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }, child:DefaultButton(onPressed: loginAdmin,title: "Login",),

            )


              ],
            ),
          ),

        ),
      ),
    );
  }
  void loginAdmin(){
  if (formKey.currentState!.validate()) {
    BlocProvider.of<AuthBlocAdmin>(context).loginViewModelAdmin(email: emailController.text, password: passwordController.text);


  }

  }


}




