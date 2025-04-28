
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';
import 'package:smart_academy/student/feature/chat/room/model/firebase_room.dart';

class FirebaseMessage{
 
 static  CollectionReference<MessageModel> getCollectionMessage(String roomId)=>FirebaseRoom.createCollectionRoom().doc(roomId).collection("message")
     .withConverter<MessageModel>(
     fromFirestore: (snapshot,_)=>MessageModel.fromJson(snapshot.data()!),
     toFirestore: (message,_)=>message.toJson()); 

 static Future<void> setMessage(MessageModel message)async{
  final messageCollection=  getCollectionMessage(message.roomId);
   final createdId=messageCollection.doc();
   message.id=createdId.id;
   return createdId.set(message);
 }

 static  Stream<List<MessageModel>> getMessage(String roomId){
  final messageCollection =  getCollectionMessage(roomId);
  return  messageCollection.orderBy("dateTime").snapshots().map((querySnapshot)=>querySnapshot.docs.map((queryDocumentSnapshot)=>queryDocumentSnapshot.data()).toList());
 }
}


