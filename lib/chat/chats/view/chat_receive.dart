
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/message_model.dart';

class ChatReceive extends StatelessWidget{
  MessageModel messageModel ;

   ChatReceive({super.key ,required this.messageModel});

  final formattedTime = DateFormat.jm().format;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(messageModel.senderName),
          Row(

            children: [

              Flexible(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70 ,
                        border: Border.all(width: 2 ,color: Colors.black),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15) ,
                          topLeft: Radius.circular(0) ,
                          bottomRight:  Radius.circular(0) ,
                          bottomLeft:  Radius.circular(15) ),
                    ),
                    child:  Text(messageModel.content,style: const TextStyle(color: Colors.black ,fontSize: 16),)),
              ) ,
           const   SizedBox(width: 15,),
               Text(formattedTime(messageModel.dateTime) ,style: const TextStyle(color: Colors.black ,fontSize: 14),),
            ],),
        ],
      ),
    );
  }
}