
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/model/firebase_parent.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view/login_parent.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/bloc_auth_parent.dart';

class PersonParent extends StatefulWidget{
  const PersonParent({super.key});

  @override
  State<PersonParent> createState() => _PersonParentState();
}

class _PersonParentState extends State<PersonParent> {

  @override
  Widget build(BuildContext context) {
    final parent=BlocProvider.of<AuthBlocParent>(context).modelParent;
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
              children: [Text("Name",style:displaySmall ) ,Text(parent!.name ,style:displaySmall?.copyWith(fontSize: 25))],) ,
            const SizedBox(height: 30,),

            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
            InkWell(
                onTap: logoutPerson,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Logout",style:displaySmall) ,
                    const SizedBox(width: 30,),const Icon(Icons.logout ,size: 35 ,color: Colors.blue ,)],))
          ],),
      ),
    );
  }
  void logoutPerson(){
    FunctionFirebaseParent.logoutParent();
    Navigator.of(context).pushReplacementNamed(LoginParent.routeName);
  }
}