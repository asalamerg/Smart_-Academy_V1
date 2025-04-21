
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatSent extends StatelessWidget{
   ChatSent({super.key});


 final String formattedTime = DateFormat.jm().format(DateTime.now());
  @override
  Widget build(BuildContext context) {


    return Row(
       crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),

            child: Text(formattedTime ,style: const TextStyle(fontSize: 15 ,fontWeight:FontWeight.w400 ),)),

       Flexible(
         child: Container(
             padding: const EdgeInsets.all(5),
             margin: const EdgeInsets.all(15),
             height: MediaQuery.of(context).size.height * 0.05,
             decoration: const BoxDecoration(
               color: Colors.blue ,
               borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , topRight: Radius.circular(10) ,bottomRight: Radius.circular(0), bottomLeft: Radius.circular(10) ) ,
             ),
         
             child: const Text(" Sent Message " ,style: TextStyle(fontSize: 20  , fontWeight: FontWeight.w400),)),
       ),

      //SizedBox(width: MediaQuery.of(context).size.width * 0.30,),



    ],);
  }
}