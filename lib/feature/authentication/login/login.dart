
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_academy/feature/authentication/register/register.dart';
import 'package:smart_academy/feature/authentication/widget/textformfield.dart';
import 'package:smart_academy/feature/home/home.dart';

class Login extends StatefulWidget{
 static const  String routeName="login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController  passwordController =TextEditingController();
  TextEditingController  EmailController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent ,title: Text("Login",style: Theme.of(context).textTheme.displayLarge,),centerTitle: true,),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(title: "Password",controller: passwordController, ),
              DefaultTextFormField(title: "Email",controller: EmailController, ),
               SizedBox(height: MediaQuery.of(context).size.height * 0.10,),

              InkWell(
                  onTap: (){
                    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                  },
                  child: Text("Login",style: Theme.of(context).textTheme.displaySmall,)),

              SizedBox(height: 10,),

              InkWell(
                  onTap: (){Navigator.of(context).pushNamed(Register.routeName);},
                  child: Text("Create an account",style: Theme.of(context).textTheme.displaySmall,)),
            ],
        ),

      ),
    );
  }

}