import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:smart_academy/shared/loading/loading.dart';
import 'package:smart_academy/shared/widget/default_button.dart';
import 'package:smart_academy/shared/widget/textformfield.dart';
import 'package:smart_academy/shared/widget/validation.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_bloc.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_status.dart';
import 'package:smart_academy/student/feature/home/view/home.dart';



class Register extends StatefulWidget{
 static const String routeName="register";

  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
            
            
            
                BlocListener<AuthBloc,AuthStatus>(  listener: (_,state){
                  if(state is RegisterAuthLoading){
                    const Loading();
                  }
                  else if(state is RegisterAuthSuccess){
                          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName ,);

                  }
                  else if(state is RegisterAuthError){
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
                },child: DefaultButton(onPressed: register,title: "Register",)),
            
            
            
            ],),
          ),
        ),
      ),
    );
  }
  void register(){
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).registerViewModel(name: nameController.text, password: passwordController.text, numberId: idController.text, email: emailController.text);


    }
  }
}
//       FunctionFirebaseUser.RegisterAccount(
//           EmailController.text,
//           NameController.text,
//           idController.text,
//           passwordController.text).
//       then((user){
//         Provider.of<UserProvider>(context ,listen: false).UpdateUser(user);
//         Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
//       }).
//       catchError((error){
//         String ? messages ;
//         if(error is FirebaseAuthException){
//           messages =error.message;
//         }
//         Fluttertoast.showToast(
//             msg: messages ??  "error",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.blue,
//             textColor: Colors.white,
//             fontSize: 16.0
//         );
//       });
//
//
//     }
//
//   }
//
// }