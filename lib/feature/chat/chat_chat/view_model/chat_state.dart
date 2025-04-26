
import 'package:smart_academy/feature/chat/chat_chat/model/message_model.dart';

abstract class ChatState{}

class ChatInitial extends ChatState{}

class SentChatStateLoading extends ChatState{}
class SentChatStateError extends ChatState{      String messageError ; SentChatStateError(this.messageError);}
class SentChatStateSuccess extends ChatState{}

class GetChatStateLoading extends ChatState{}
class GetChatStateError extends ChatState{        String messageError ; GetChatStateError(this.messageError);}
class GetChatStateSuccess extends ChatState{
  Stream<List<MessageModel>> messageStream ;
  GetChatStateSuccess({required this.messageStream});
}