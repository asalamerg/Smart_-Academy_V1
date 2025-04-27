import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/feature/authentication/model/firebaseFunctionUser.dart';
import 'package:smart_academy/feature/authentication/view/screen_ui/login/login.dart';
import 'package:smart_academy/feature/authentication/view_model/auth_bloc.dart';

class Person extends StatefulWidget{
  const Person({super.key});

  @override
  State<Person> createState() => _PersonState();
}


class _PersonState extends State<Person> {
  @override
  Widget build(BuildContext context) {
 final  user= BlocProvider.of<AuthBloc>(context).modelUser;
   final displaySmall =Theme.of(context).textTheme.displaySmall;
    return  Scaffold(

      body: Container(

        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(13),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)) ,
          border: Border.all(width: 2,color: Colors.blue)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/learing.jpg" ,width: 300 ,height: 250,),

            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("Name",style:displaySmall ) ,Text(user!.name ,style:displaySmall?.copyWith(fontSize: 25))],) ,
            const SizedBox(height: 30,),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("Id",style:displaySmall) , Text(user.numberId,style:displaySmall?.copyWith(fontSize: 25))],) ,
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),        InkWell(
              onTap: logout,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text("Logout",style:displaySmall) ,     const SizedBox(width: 30,),const Icon(Icons.logout ,size: 35 ,color: Colors.blue ,)],))
        ],),
      ),
    );
  }

  void logout(){
    FunctionFirebaseUser.logout();
    Navigator.of(context).pushReplacementNamed(Login.routeName) ;
  }
}