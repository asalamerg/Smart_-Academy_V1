

import 'package:flutter/material.dart';

class  DefaultTextField extends StatelessWidget{
  TextEditingController controllerContent;

   DefaultTextField({super.key , required this.controllerContent,  });

  @override
  Widget build(BuildContext context) {
    return TextField(
       controller: controllerContent,

      decoration: InputDecoration(
        hintText: "رسالتك هنا...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey[500]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey[500]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textDirection: TextDirection.rtl,
      maxLines: 5,
      minLines: 1,
    );
  }
}