
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:smart_academy/shared/loading/loading.dart';
import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';
import 'package:smart_academy/student/feature/authentication/view/screen_ui/register/register.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_bloc.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_status.dart';
import 'package:smart_academy/student/feature/home/view/home.dart';


class Login extends StatefulWidget{
 static const  String routeName="login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            
                  BlocListener<AuthBloc,AuthStatus>( listener: (_,state){
                    if(state is LoginAuthLoading){
                      const Loading();
                    }
                    else if (state is LoginAuthSuccess){
                      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                    }
                    else if (state is LoginAuthError){
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
                  }, child: DefaultButton(onPressed: login,title: "Login",)),
            
            
                  const SizedBox(height: 10,),
            
                  InkWell(
                      onTap: (){Navigator.of(context).pushNamed(Register.routeName);},
                      child: Text("Create an account",style: Theme.of(context).textTheme.displaySmall,)),
                ],
            ),
          ),

        ),
      ),
    );
  }
  void login(){
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).loginViewModel(email: emailController.text, password: passwordController.text);

    }

  }

}

      // FunctionFirebaseUser.LoginAccount(
      //     EmailController.text ,
      //     passwordController.text).
      // then((user){
      //   Provider.of<UserProvider>(context,listen: false).UpdateUser(user);
      //   Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      //
      // }).
      // catchError((error){
      //   String ? messages ;
      //   if(error is FirebaseAuthException){
      //     messages =error.message;
      //   }
      //   Fluttertoast.showToast(
      //       msg:messages ?? " error",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.blue,
      //       textColor: Colors.white,
      //       fontSize: 16.0
      //   );
      // });

