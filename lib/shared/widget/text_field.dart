

import 'package:flutter/material.dart';

class  DefaultTextField extends StatelessWidget{
  TextEditingController controllerContent;

   DefaultTextField({super.key , required this.controllerContent, required String hintText, required Future<void> Function(dynamic _) onSubmitted , });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: TextField(
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
        maxLines: 3,
        minLines: 1,
      ),
    );
  }
}