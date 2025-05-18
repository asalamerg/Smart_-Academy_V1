import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/student/feature/chat/room/model/firebase_room.dart';
import 'package:smart_academy/student/feature/chat/room/model/room_model.dart';
import 'package:smart_academy/student/feature/chat/room/view_model/status_room.dart';

class ViewModelRoom extends Cubit<StatusRoom> {
  ViewModelRoom() : super(RoomInitial());

  List<RoomModel> rooms = [];

  Future<void> loadRooms() async {
    emit(RoomLoading());
    try {
      rooms = await FirebaseRoom.getRoomFromFirebase();
      emit(RoomLoaded());
    } catch (error) {
      emit(RoomError(error.toString()));
    }
  }

  Future<void> createRoom(RoomModel room) async {
    emit(CreateRoomLoading());
    try {
      await FirebaseRoom.createRoomFromFirebase(room);
      emit(CreateRoomSuccess());
    } catch (error) {
      emit(CreateRoomError(error.toString()));
    }
  }

  Future<void> deleteRoom(String roomId) async {
    emit(DeleteRoomLoading());
    try {
      await FirebaseRoom.deleteRoomFromFirebase(roomId);
      rooms.removeWhere((room) => room.id == roomId);
      emit(DeleteRoomSuccess());
    } catch (e) {
      emit(DeleteRoomError(e.toString()));
    }
  }
}