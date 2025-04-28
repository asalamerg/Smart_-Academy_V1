
import 'package:flutter/material.dart';

class ScreenHomeParent extends StatelessWidget{
 static const  String routeName="ScreenHomeParent";
   const ScreenHomeParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: const Center(child: Text("ADMIN"),),
    );
  }
}