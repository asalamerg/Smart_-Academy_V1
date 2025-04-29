
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view/login_admin.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view_model/auth_bloc_admin.dart';

import '../../authentication_admin/model/firebase_admin.dart';

class PersonAdmin extends StatefulWidget{
  const PersonAdmin({super.key});

  @override
  State<PersonAdmin> createState() => _PersonAdminState();
}

class _PersonAdminState extends State<PersonAdmin> {

  @override
  Widget build(BuildContext context) {
    final personA=BlocProvider.of<AuthBlocAdmin>(context).modelAdmin;
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
              children: [Text("Name",style:displaySmall ) ,Text(personA!.name ,style:displaySmall?.copyWith(fontSize: 25))],) ,
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
    FunctionFirebaseAdmin.logoutAdmin();
    Navigator.of(context).pushReplacementNamed(LoginAdmin.routeName);
  }
}