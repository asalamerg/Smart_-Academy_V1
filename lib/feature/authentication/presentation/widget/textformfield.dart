
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget{
  String title ;
  TextEditingController controller ;
  String? Function(String?)? validator ;
  DefaultTextFormField({required this.title, required this.controller , this.validator});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        style: Theme.of(context).textTheme.displaySmall,
        controller: controller,
        decoration: InputDecoration(
          hintText: title
        ),
         validator: validator,
      ),
    );
  }
}