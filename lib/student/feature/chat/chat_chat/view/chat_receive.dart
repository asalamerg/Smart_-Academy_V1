
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';

class  ChatReceive extends  StatelessWidget{
  final MessageModel messageModel ;
    const ChatReceive({super.key ,required this.messageModel});


 // final String formattedTime = DateFormat.jm().format(DateTime.now()); // 5:08 PM

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(padding: const EdgeInsets.all(8.0),
          child: Text(messageModel.receiveName,style: const TextStyle(fontSize: 14, color: Colors.blue),),
        ),
        const SizedBox(height: 4,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  margin:  const EdgeInsets.symmetric(vertical: 3,horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: const BoxDecoration(
                    color: Colors.grey ,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0) , topRight: Radius.circular(10) ,bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10) ) ,
                  ),

                  child:  Text(messageModel.content ,maxLines: 5 ,overflow: TextOverflow.ellipsis ,style: const TextStyle(fontSize: 18  , fontWeight: FontWeight.w400 ,color: Colors.white) ,) ),
            ),



            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child:  Text(DateFormat.jm().format(messageModel.dateTime)
                  ,style: const TextStyle(fontSize: 15 ,fontWeight:FontWeight.w400 ),),),

          ],),
      ],
    );
  }
}