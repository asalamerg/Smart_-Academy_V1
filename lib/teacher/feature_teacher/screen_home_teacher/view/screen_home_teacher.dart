

import 'package:flutter/material.dart';
import 'package:smart_academy/shared/theme/apptheme.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/dashbord_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/person_teacher/view/person_teacher.dart';

class HomeScreenTeacher extends StatefulWidget{
  static const  String routeName="HomeScreenTeacher";

  const HomeScreenTeacher({super.key});

  @override
  State<HomeScreenTeacher> createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends State<HomeScreenTeacher> {
  int select=0;
  List<Widget> item=[
    DashbordTeacher(),
    PersonTeacher(),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
        ),
        child: Scaffold(
        appBar: AppBar(  leading: Container() ,title: Text(item[select].toString() ,style: Theme.of(context).textTheme.displayLarge,),centerTitle: true,),
    body: item[select],

    bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.shifting,
    selectedItemColor: AppTheme.blu,
    unselectedItemColor: Colors.black,

    currentIndex: select,

    onTap: (index){
    select=index;
    setState(() {

    });
    },
    items: const [

    BottomNavigationBarItem(icon: Icon(Icons.dashboard,size: 35,),label: "DashBord",),

    BottomNavigationBarItem(icon: Icon(Icons.person ,size: 35,),label: "person"),
    ])
    ));
  }
}