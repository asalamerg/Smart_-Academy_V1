import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Register" ,style: Theme.of(context).textTheme.displayLarge,),centerTitle: true,),
        body: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
          DefaultTextFormField(title: "Name",controller: NameController, ),
          DefaultTextFormField(title: "Email",controller: EmailController, ),
          DefaultTextFormField(title: "Password",controller: passwordController, ),
          DefaultTextFormField(title: "ID",controller: idController, ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10,),

            InkWell(
              onTap: (){Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);},
              child: Text("register ",style: Theme.of(context).textTheme.displaySmall,)),

        ],),
      ),
    );
  }
}