
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/student/feature/chat/room/model/firebase_room.dart';
import 'package:smart_academy/student/feature/chat/room/model/room_model.dart';

import 'status_room.dart';

class ViewModelRoom extends Cubit<StatusRoom>{
  ViewModelRoom():super (RoomInitial());

  List<RoomModel> rooms=[];

  Future<void> getRoomViewModel()async{
    emit(GetRoomLoading());
    try{
       rooms=await FirebaseRoom.getRoomFromFirebase();
      emit(GetRoomSuccess());
    }catch(error){
      emit(GetRoomError(message: error.toString()));
    }
  }

  Future<void> createRoomViewModel(RoomModel room )async{
    emit(CreateRoomLoading());
    try{
     await FirebaseRoom.createRoomFromFirebase(room);
     emit(CreateRoomSuccess()) ;
    }catch(error){
      emit(CreateRoomError(message: error.toString()));
    }
  }

  Future<void> deleteRoomViewModel(String roomId)async{

    emit(DeleteRoomLoading());
    try{
      await FirebaseRoom.deleteRoomFromFirebase(roomId);
      rooms.removeWhere((room) => room.id == roomId);

      emit(DeleteRoomSuccess());    }
    catch(e){
      emit(DeleteRoomError(message: e.toString()));
    }

  }

}