import 'package:flutter/material.dart';
import 'package:smart_academy/feature/dashbord/model/model_dashboard.dart';
import 'package:smart_academy/feature/dashbord/view/item_dashbord.dart';

class Dashbord extends StatelessWidget{
  Dashbord({super.key});


  List<ModelDashboard> listDash=[
    ModelDashboard( name: "ALGORITHMS AND PROGRAMMING TECHNIQUES ", basic: const Color(0xffE0F7FA), complete: "0% complete", primary: const Color(0xff00BCD4)),
    ModelDashboard( name: "DATA STRUCTURES ", basic: const Color(0xffFFFFFF), complete: "0% complete", primary: const Color(0xffF44336)),
    ModelDashboard( name: "FUNDAMENTALS OF COMPUTER GRAPHICS ", basic: const Color(0xffF3F3F3), complete: "0% complete", primary: const Color(0xffE91E63)),
    ModelDashboard( name: "INTRODUCTION TO COMPUTER ORGANIZATION ", basic: const Color(0xffFAFAFA), complete: "0% complete", primary: const Color(0xff3F51B5)),
    ModelDashboard( name: "INTRODUCTION TO DATABASE ", basic: const Color(0xffFFFFFF), complete: "0% complete", primary: const Color(0xff4CAF50)),
    ModelDashboard( name: "INTRODUCTION TO OPERATING SYSTEMS ", basic: const Color(0x0ff5f5f5), complete: " 0% complete ", primary: const Color(0xff9C27B0)),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  ListView.builder(itemBuilder: (context,index)=> ItemDashboard(modelDashboard: listDash[index] ,), itemCount: listDash.length,),
    );
  }
}