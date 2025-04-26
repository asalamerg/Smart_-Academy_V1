
import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget{
final  String message ;
  const ErrorIndicator({super.key ,  this.message ="يوجد خطا ما !"});



  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(
       color: Colors.blue,

    ),);
  }
}