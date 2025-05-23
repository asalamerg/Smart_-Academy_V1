

import 'package:smart_academy/chat/chats/model/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class SentChatLoading extends ChatState {}

class SentChatSuccess extends ChatState {}

class SentChatError extends ChatState {  final String message;  SentChatError(this.message);}

class GetChatLoading extends ChatState {}

class GetChatSuccess extends ChatState {
  Stream<List<MessageModel>> streamMessage;
  GetChatSuccess(this.streamMessage);
}

class GetChatError extends ChatState { final String message;  GetChatError(this.message);}