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




class RegisterParent extends StatefulWidget{
  static const String routeName="RegisterParent";

  const RegisterParent({super.key});

  @override
  State<RegisterParent> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterParent> {
  TextEditingController  passwordController =TextEditingController();
  TextEditingController  emailController =TextEditingController();
  TextEditingController nameController =TextEditingController();
  TextEditingController  idController =TextEditingController();
  var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key:formKey ,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text("Register" ,style: Theme.of(context).textTheme.displayLarge,),centerTitle: true,),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextFormField(title: "Name",controller: nameController,validator: validation.name, ),
                DefaultTextFormField(title: "Email",controller: emailController, validator: validation.email,),
                DefaultTextFormField(title: "Password",controller: passwordController,validator: validation.password, ),
                DefaultTextFormField(title: "ID",controller: idController, validator: validation.id,),
                SizedBox(height: MediaQuery.of(context).size.height * 0.10,),





            BlocListener<AuthBlocParent,AuthStatusParent>(  listener: (_,state){
              if(state is RegisterAuthLoadingParent){
                const Loading();
              }
              else if(state is RegisterAuthSuccessParent){
                Navigator.of(context).pushReplacementNamed(ScreenHomeParent.routeName ,);

              }
              else if(state is RegisterAuthErrorParent){
                Fluttertoast.showToast(
                    msg: state.error ,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            },child:DefaultButton(onPressed: registerParent,title: "Register",)



            )],),
          ),
        ),
      ),
    );
  }
void registerParent(){
  if (formKey.currentState!.validate()) {
    BlocProvider.of<AuthBlocParent>(context).registerViewModelParent(name: nameController.text, password: passwordController.text, numberId: idController.text, email: emailController.text);


  }
}
}
