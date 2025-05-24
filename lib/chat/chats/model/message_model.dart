
import 'package:cloud_firestore/cloud_firestore.dart';



class MessageModel{
  String id ;
  String senderId ;
  String senderName ;
  String content ;
  String roomId ;
  DateTime dateTime ;

  MessageModel({
    this.id ='' ,
    required this.dateTime ,
    required this.content ,
    required this.roomId ,
    required this.senderId ,
    required this.senderName ,
  });

 Map<String,dynamic>  toJson()=>{
   "id" : id ,
   "dateTime" : dateTime ,
   "content" : content ,
   "roomId" : roomId ,
   "senderId" : senderId ,
   "senderName" : senderName ,
 };

 MessageModel.fromJson(Map<String ,dynamic> json): this (
   id: json ["id"]  ,
   dateTime: (json ["dateTime"] as Timestamp).toDate()  ,
   content: json ["content"]  ,
   roomId: json ["roomId"]  ,
   senderId: json ["senderId"]  ,
   senderName: json ["senderName"]  ,
 );


}