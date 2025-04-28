
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';

class ChatSent extends StatelessWidget{
  final MessageModel messageModel ;
   const  ChatSent({super.key ,required this.messageModel});


  @override
  Widget build(BuildContext context) {


    return Row(
       crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),

            child:  Text(DateFormat.jm().format(messageModel.dateTime)  ,style: const TextStyle(fontSize: 15 ,fontWeight:FontWeight.w400 ),)),

       Flexible(
         child: Container(
             padding: const EdgeInsets.all(5),
             margin: const EdgeInsets.all(15),
             height: MediaQuery.of(context).size.height * 0.05,
             decoration: const BoxDecoration(
               color: Colors.blue ,
               borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , topRight: Radius.circular(10) ,bottomRight: Radius.circular(0), bottomLeft: Radius.circular(10) ) ,
             ),
         
             child:  Text(messageModel.content ,style: const TextStyle(fontSize: 20  , fontWeight: FontWeight.w400),)),
       ),

      //SizedBox(width: MediaQuery.of(context).size.width * 0.30,),



    ],);
  }
}