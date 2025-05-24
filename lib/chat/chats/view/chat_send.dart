
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_academy/chat/chats/model/message_model.dart';

// class ChatSent extends StatelessWidget{
//   MessageModel messageModel ;
//
//    ChatSent({super.key ,required this.messageModel});
//   final formattedTime = DateFormat.jm().format;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Row(
//
//         children: [
//           const Text("2/2/33"
//
//             ,style: TextStyle(color: Colors.black ,fontSize: 14),),
//           const   SizedBox(width: 15,),
//           Flexible(
//             child: Container(
//                 padding: const EdgeInsets.all(10),
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: Colors.blue ,
//                     border: Border.all(width: 2 ,color: Colors.black),
//                     borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(0) ,
//                         topLeft: Radius.circular(15) ,
//                         bottomRight:  Radius.circular(15) ,
//                         bottomLeft:  Radius.circular(0) ),
//                     ),
//                 child:  Text(formattedTime(messageModel.dateTime),style: const TextStyle(color: Colors.white ,fontSize: 16),maxLines: 5,)),
//           ) ,
//         ],),
//     );
//   }
// }



class ChatSent extends StatelessWidget {
  final MessageModel messageModel;
  final formattedTime = DateFormat.jm().format;

   ChatSent({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(messageModel.senderName),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(0),
                    ),
                  ),
                  child: Text(
                    messageModel.content,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    maxLines: 5,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                formattedTime(messageModel.dateTime),
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}