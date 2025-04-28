
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id ;
  String roomId ;
  String  sentId;
  String  receiveName; //receive
  DateTime dateTime ;
  String  content ;


  MessageModel({ this.id="" , required this.roomId ,required this.sentId ,required this.dateTime ,
    required this.content  ,required this.receiveName});

  MessageModel.fromJson(Map<String ,dynamic> json) :this(
      id :json["id"] ,
    roomId :json["roomId"] ,
    sentId :json["sentId"] ,
    dateTime : ( json["dateTime"] as Timestamp ).toDate() ,
    content :json["content"] ,
    receiveName :json["receiveName"] ,
  );

 Map<String,dynamic> toJson()=>{
   "id" : id ,
   "roomId" :roomId  ,
   "sentId" :sentId ,
   "dateTime" :FieldValue.serverTimestamp(),  // Timestamp.fromDate(dateTime)  ,
   "content" :content ,

   "receiveName" : receiveName
 };

}