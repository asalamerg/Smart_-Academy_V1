
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/firebase_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view/login_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view_model/auth_bloc_teacher.dart';

class PersonTeacher extends StatefulWidget{
  @override
  State<PersonTeacher> createState() => _PersonTeacherState();
}

class _PersonTeacherState extends State<PersonTeacher> {
  @override
  Widget build(BuildContext context) {
    final teacher=BlocProvider.of<AuthBlocTeacher>(context).modelTeacher;
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


    SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [Text("Name",style:displaySmall ) ,Text(teacher!.name ,style:displaySmall?.copyWith(fontSize: 25))],) ,
    const SizedBox(height: 30,),

    SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
    InkWell(
    onTap: logoutTeacher,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [Text("Logout",style:displaySmall) ,
    const SizedBox(width: 30,),const Icon(Icons.logout ,size: 35 ,color: Colors.blue ,)],))
    ],),
    ),
    );
  }
  void logoutTeacher(){
    FunctionFirebaseTeacher.logoutTeacher();
    Navigator.of(context).pushReplacementNamed(LoginTeacher.routeName);
  }

}