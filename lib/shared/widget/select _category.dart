
import 'package:flutter/material.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view/login_parent.dart';
import 'package:smart_academy/student/feature/authentication/view/screen_ui/login/login.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view/login_teacher.dart';

class SelectCategory extends StatelessWidget{
  static const String routeName="SelectCategory";

  const SelectCategory({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
      ),
      child: Scaffold(
        appBar: AppBar( title: Text("Smart Academy",style: Theme.of(context).textTheme.displayLarge),centerTitle: true,),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height:MediaQuery.of(context).size.height * 0.1 ,),
                  const Text("نحو مستقبل تعليمي أفضل وأكثر تميزًا" ,style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold ),),
              SizedBox(height:MediaQuery.of(context).size.height * 0.2 ,),
             
             InkWell(
                 onTap: (){
                   Navigator.of(context).pushNamed(Login.routeName);
                 },
                 child: const Text("Student",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold ))),

              const SizedBox(height:30 ,),

            InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(LoginTeacher.routeName);

                },
                child: const Text("Teacher",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold ,color: Colors.blue))),

              const SizedBox(height:30 ,),

            InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(LoginParent.routeName);
                },
                child: const Text("Parent",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold ))),
              const SizedBox(height:30 ,),
              InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed(Login.routeName);
                  },
                  child: const Text("Admin ",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold ,color: Colors.blue))),
          ],),
        ),
      ),
    );
  }
}