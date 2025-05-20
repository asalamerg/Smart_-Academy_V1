
abstract class StatusRoom {}

class RoomInitial extends StatusRoom {}

class GetRoomLoading extends StatusRoom {}
class GetRoomSuccess extends StatusRoom {}
class GetRoomError extends StatusRoom {
  final String message;
  GetRoomError(this.message);
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