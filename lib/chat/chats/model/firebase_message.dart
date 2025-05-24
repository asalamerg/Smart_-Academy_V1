

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../room/model/firebase_room.dart';
import 'message_model.dart';

// class FirebaseMessage {
//
//   static  CollectionReference<MessageModel> getCollectionMessage(String roomId)=>FirebaseRoom.createCollectionRoom().doc(roomId).collection("message")
//       .withConverter<MessageModel>(
//       fromFirestore: (snapshot,_)=>MessageModel.fromJson(snapshot.data()!),
//       toFirestore: (message,_)=>message.toJson());
//
//   static Future<void> insertMessageToRoom(MessageModel message)async{
//       final messageCollection=  getCollectionMessage(message.roomId);
//       final createdId=messageCollection.doc();
//       message.id=createdId.id;
//       return createdId.set(message);
//   }
//
//   static  Stream<List<MessageModel>> getMessage(String roomId){
//     final messageCollection =  getCollectionMessage(roomId);
//     return  messageCollection.snapshots().map((querySnapshot)=>querySnapshot.docs.map((queryDocumentSnapshot)=>queryDocumentSnapshot.data()).toList());}
//
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/chat/room/model/firebase_room.dart';
import 'message_model.dart';

class FirebaseMessage {
  static CollectionReference<MessageModel> getCollectionMessage(String roomId) {
    return FirebaseRoom.createCollectionRoom()
        .doc(roomId)
        .collection("messages") // تغيير من "message" إلى "messages"
        .withConverter<MessageModel>(
      fromFirestore: (snapshot, _) => MessageModel.fromJson(snapshot.data()!),
      toFirestore: (message, _) => message.toJson(),
    );
  }

  static Future<void> insertMessageToRoom(MessageModel message) async {
    try {
      final messageCollection = getCollectionMessage(message.roomId);
      final createdId = messageCollection.doc();
      message.id = createdId.id;
      await createdId.set(message);
    } catch (e) {
      throw Exception('Failed to insert message: $e');
    }
  }

  static Stream<List<MessageModel>> getMessage(String roomId) {
    final messageCollection = getCollectionMessage(roomId);
    return messageCollection
        .orderBy('dateTime', descending: true) // إضافة ترتيب حسب التاريخ
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((queryDocumentSnapshot) => queryDocumentSnapshot.data())
        .toList());
  }
}