
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
static const  String routeName="home";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Welcome"),),

      ),
    );
  }
}