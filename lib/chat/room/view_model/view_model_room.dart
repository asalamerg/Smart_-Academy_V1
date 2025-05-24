
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/chat/room/model/firebase_room.dart';
import 'package:smart_academy/chat/room/model/room_model.dart';
import 'package:smart_academy/chat/room/view_model/status_room.dart';



class RoomViewModel extends Cubit<StatusRoom>{
  RoomViewModel() :super(RoomInitial());

  List<RoomModel> rooms=[];

   Future<void> getRoom()async{
     emit(GetRoomLoading());
     try{
    rooms=  await  FirebaseRoom.getRoomFromFirebase();
     emit(GetRoomSuccess());
     }catch(e){
       emit(GetRoomError(e.toString()));
     }
   }

  Future<void> createRoomFrom(RoomModel roomModel)async{

     emit(CreateRoomLoading());
     try{
        await FirebaseRoom.createRoomFromFirebase(roomModel);
       emit(CreateRoomSuccess());
     }catch(e){
       emit(CreateRoomError(e.toString()));
     }
  }


  Future<void> deleteRoom(String roomId) async {
    emit(DeleteRoomLoading());
    try {
      // حذف من Firebase
      await FirebaseRoom.deleteRoomFromFirebase(roomId);

      // حذف من القائمة المحلية
      rooms.removeWhere((room) => room.id == roomId);

      // إرسال حالة جديدة لتحديث الواجهة
      emit(GetRoomSuccess()); // لتحديث الواجهة تلقائيًا

    } catch (e) {
      emit(DeleteRoomError(e.toString()));
    }
  }


}