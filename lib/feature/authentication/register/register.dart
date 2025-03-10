import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_academy/feature/authentication/widget/default_button.dart';
import 'package:smart_academy/feature/authentication/widget/validation.dart';
import 'package:smart_academy/feature/home/home.dart';

import '../widget/textformfield.dart';

class Register extends StatefulWidget{
 static const String routeName="register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController  passwordController =TextEditingController();
  TextEditingController  EmailController =TextEditingController();
  TextEditingController NameController =TextEditingController();
  TextEditingController  idController =TextEditingController();
  var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key:formKey ,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text("Register" ,style: Theme.of(context).textTheme.displayLarge,),centerTitle: true,),
          body: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
            DefaultTextFormField(title: "Name",controller: NameController,validator: validation.name, ),
            DefaultTextFormField(title: "Email",controller: EmailController, validator: validation.email,),
            DefaultTextFormField(title: "Password",controller: passwordController,validator: validation.password, ),
            DefaultTextFormField(title: "ID",controller: idController, validator: validation.id,),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10,),
              DefaultButton(onPressed: (){
                if (formKey.currentState!.validate()) {
                  register();

                }


              },title: "Register",),



          ],),
        ),
      ),
    );
  }
  void register(){
    Navigator.of(context).pushNamed(HomeScreen.routeName);
  }

}