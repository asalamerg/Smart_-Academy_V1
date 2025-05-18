//
// abstract class  StatusRoom {}
//
// class RoomInitial extends StatusRoom{}
//
//
//
// class GetRoomLoading extends StatusRoom{}
// class GetRoomError extends StatusRoom{String message ;GetRoomError({required this.message});}
// class GetRoomSuccess extends StatusRoom{}
//
//
// class CreateRoomLoading extends StatusRoom{}
// class CreateRoomError extends StatusRoom{ String message ;CreateRoomError({required this.message});}
// class CreateRoomSuccess extends StatusRoom{}
//
//
// class DeleteRoomLoading extends StatusRoom{}
// class DeleteRoomError extends StatusRoom{String message ;DeleteRoomError({required this.message});}
// class DeleteRoomSuccess extends StatusRoom{}
abstract class StatusRoom {}

class RoomInitial extends StatusRoom {}

class RoomLoading extends StatusRoom {}
class RoomLoaded extends StatusRoom {}
class RoomError extends StatusRoom {
  final String message;
  RoomError(this.message);
}

class CreateRoomLoading extends StatusRoom {}
class CreateRoomSuccess extends StatusRoom {}
class CreateRoomError extends StatusRoom {
  final String message;
  CreateRoomError(this.message);
}

class DeleteRoomLoading extends StatusRoom {}
class DeleteRoomSuccess extends StatusRoom {}
class DeleteRoomError extends StatusRoom {
  final String message;
  DeleteRoomError(this.message);
}