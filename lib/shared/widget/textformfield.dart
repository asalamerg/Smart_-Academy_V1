
import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget{
  String title ;
  TextEditingController controller ;
  String? Function(String?)? validator ;
  DefaultTextFormField({super.key, required this.title, required this.controller , this.validator});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
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