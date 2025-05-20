
import 'package:cloud_firestore/cloud_firestore.dart';

// class MessageModel {
//   String id ;
//   String roomId ;
//   String  sentId;
//   String  receiveName; //receive
//   DateTime  dateTime ;  //dateTime ;
//   String  content ;
//
//
//   MessageModel({ this.id="" , required this.roomId ,required this.sentId ,required this.dateTime ,
//     required this.content  ,required this.receiveName});
//
//  //  MessageModel.fromJson(Map<String ,dynamic> json) :this(
//  //      id :json["id"] ,
//  //    roomId :json["roomId"] ,
//  //    sentId :json["sentId"] ,
//  //    dateTime : ( json["dateTime"] as Timestamp ).toDate() ,
//  //    content :json["content"] ,
//  //    receiveName :json["receiveName"] ,
//  //  );
//  //
//  // Map<String,dynamic> toJson()=>{
//  //   "id" : id ,
//  //   "roomId" :roomId  ,
//  //   "sentId" :sentId ,
//  //   "dateTime": Timestamp.fromDate(dateTime),  //"dateTime" :FieldValue.serverTimestamp(),  // Timestamp.fromDate(dateTime)  ,
//  //   "content" :content ,
//  //   "receiveName" : receiveName
//  // };
//
//
//   MessageModel.fromJson(Map<String,dynamic> json) :this(
//     id: json["id"] ?? "",
//     roomId: json["roomId"] ?? "",
//     sentId: json["sentId"] ?? "",
//     dateTime: (json["dateTime"] as Timestamp?)?.toDate() ?? DateTime.now(),
//     content: json["content"] ?? "",
//     receiveName: json["receiveName"] ?? "",
//   );
//
//   Map<String,dynamic> toJson() => {
//     "id": id,
//     "roomId": roomId,
//     "sentId": sentId,
//     "dateTime": dateTime, // إرسال التاريخ الفعلي
//     "content": content,
//     "receiveName": receiveName
//   };
//
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String roomId;
  final String sentId;
  final String receiveName;
  final DateTime dateTime;
  final String content;

  MessageModel({
    this.id = "",
    required this.roomId,
    required this.sentId,
    required this.receiveName,
    required this.dateTime,
    required this.content,
  });

  MessageModel copyWith({
    String? id,
    String? roomId,
    String? sentId,
    String? receiveName,
    DateTime? dateTime,
    String? content,
  }) {
    return MessageModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      sentId: sentId ?? this.sentId,
      receiveName: receiveName ?? this.receiveName,
      dateTime: dateTime ?? this.dateTime,
      content: content ?? this.content,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["id"] ?? "",
    roomId: json["roomId"] ?? "",
    sentId: json["sentId"] ?? "",
    receiveName: json["receiveName"] ?? "",
    dateTime: (json["dateTime"] as Timestamp).toDate(),
    content: json["content"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "roomId": roomId,
    "sentId": sentId,
    "receiveName": receiveName,
    "dateTime": Timestamp.fromDate(dateTime),
    "content": content,
  };
}