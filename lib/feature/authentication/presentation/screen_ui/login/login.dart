
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_academy/feature/authentication/data/firebaseFunctionUser.dart';
import 'package:smart_academy/feature/authentication/data/user_provder.dart';
import 'package:smart_academy/feature/authentication/presentation/screen_ui/register/register.dart';
import 'package:smart_academy/feature/authentication/presentation/widget/default_button.dart';
import 'package:smart_academy/feature/authentication/presentation/widget/textformfield.dart';
import 'package:smart_academy/feature/authentication/presentation/widget/validation.dart';

import 'package:smart_academy/feature/home/home.dart';


class Login extends StatefulWidget{
 static const  String routeName="login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController  passwordController =TextEditingController();
  TextEditingController  EmailController =TextEditingController();
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextFormField(title: "Email",controller: EmailController, validator: validation.email,),
                DefaultTextFormField(title: "Password",controller: passwordController,validator: validation.password ),


                 SizedBox(height: MediaQuery.of(context).size.height * 0.20,),
                DefaultButton(onPressed: Login,title: "Login",),


                const SizedBox(height: 10,),

                InkWell(
                    onTap: (){Navigator.of(context).pushNamed(Register.routeName);},
                    child: Text("Create an account",style: Theme.of(context).textTheme.displaySmall,)),
              ],
          ),

        ),
      ),
    );
  }
  void Login(){
    if (formKey.currentState!.validate()) {
      FunctionFirebaseUser.LoginAccount(
          EmailController.text ,
          passwordController.text).
      then((user){
        Provider.of<UserProvider>(context,listen: false).UpdateUser(user);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

      }).
      catchError((error){
        String ? messages ;
        if(error is FirebaseAuthException){
          messages =error.message;
        }
        Fluttertoast.showToast(
            msg:messages ?? " error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });

    }

  }

}