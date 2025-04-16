import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Person extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Person",style: Theme.of(context).textTheme.displayLarge, ),),

    );
  }
}