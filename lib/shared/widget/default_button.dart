
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget{
  void Function()? onPressed ;
  String title;
  DefaultButton({super.key, required this.onPressed ,required this.title});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed ,style:ElevatedButton.styleFrom(
      fixedSize: Size(MediaQuery.of(context).size.width * 0.80, 55 ),
      backgroundColor: Colors.blue
    ) ,
        child: Text(title ,style: const TextStyle(fontSize: 20 ,color: Colors.white),));
  }
}