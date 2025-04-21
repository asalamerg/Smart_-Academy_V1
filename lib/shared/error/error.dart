
import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget{
  String message ;
  ErrorIndicator({super.key , required this.message});



  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(
       color: Colors.blue,

    ),);
  }
}