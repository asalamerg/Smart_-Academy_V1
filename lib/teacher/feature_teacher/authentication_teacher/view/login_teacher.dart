


import 'package:flutter/material.dart';
import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';

import 'register_teacher.dart';

class LoginTeacher extends StatefulWidget{
  static const  String routeName="LoginTeacher";

  const LoginTeacher({super.key});

  @override
  State<LoginTeacher> createState() => _LoginState();
}

class _LoginState extends State<LoginTeacher> {
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
                    onTap: (){Navigator.of(context).pushNamed(RegisterTeacher.routeName);},
                    child: Text("Create an account",style: Theme.of(context).textTheme.displaySmall,)),

                const SizedBox(height:30),
                 DefaultButton(onPressed: (){},title: "Login",),


                const SizedBox(height: 10,),


              ],
            ),
          ),

        ),
      ),
    );
  }


  }




