
import 'package:flutter/material.dart';

class ScreenHomeAdmin extends StatelessWidget{
  static const  String routeName="ScreenHomeAdmin";

  const ScreenHomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text("ADMIN"),),
    );
  }
}