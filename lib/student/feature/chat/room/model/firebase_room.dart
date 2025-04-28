
import 'package:cloud_firestore/cloud_firestore.dart';

import 'room_model.dart';

class FirebaseRoom{

static  CollectionReference<RoomModel>  createCollectionRoom()=>FirebaseFirestore.instance.collection("Room")
      .withConverter<RoomModel>(
      fromFirestore: (docSnapShot,_)=>RoomModel.fromJson(docSnapShot.data()!),
      toFirestore: (model,_)=>model.toJson() );



  static  Future<List<RoomModel>> getRoomFromFirebase()async{
     CollectionReference<RoomModel> getRoom=createCollectionRoom();
QuerySnapshot<RoomModel> querySnapshot= await getRoom.get();

return  querySnapshot.docs.map((docSnapShot)=>docSnapShot.data()).toList();

  }


  static Future<void> createRoomFromFirebase (RoomModel room )async{
    CollectionReference createRooms =createCollectionRoom();

    final createId=createRooms.doc();
     room.id =createId.id;
   return  createId.set(room);

  }


  static Future<void> deleteRoomFromFirebase(String roomId)async{
    CollectionReference getCollection =createCollectionRoom();
   return  getCollection.doc(roomId).delete();

  }
}