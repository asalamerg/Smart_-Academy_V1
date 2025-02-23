import 'package:flutter/material.dart';

void main() {
  runApp( const SmartAcademy());
}

class SmartAcademy extends StatelessWidget{
  const SmartAcademy({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     home: Scaffold(
       appBar: AppBar(title: const Text("HOME"),),
       body: const Center(child: Text("ahmad"),),
     ),
   );
  }
}