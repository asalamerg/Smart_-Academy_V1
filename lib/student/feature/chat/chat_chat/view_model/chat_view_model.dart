//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/model/firebase_message.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/view_model/chat_state.dart';
//
//
// class ChatViewModel extends Cubit<ChatState>{
//   ChatViewModel() :super(ChatInitial());
//
//
//   Future<void> sentMessageViewModel(MessageModel message)async{
//
//
//     emit(SentChatStateLoading());
//     try{
//      await FirebaseMessage.setMessage(message);
//      emit(SentChatStateSuccess()) ;
//     }catch(e){
//       emit(SentChatStateError(e.toString()));
//     }
//
//   }
//
//   Future<void> getMessageViewModelStream(String roomId)async{
//
//     emit(GetChatStateLoading()) ;
//     try{
//    final listMessageStream=   FirebaseMessage.getMessage(roomId);
//      emit(GetChatStateSuccess(messageStream: listMessageStream));
//
//     }catch(e){
//       emit(GetChatStateError(e.toString()));
//
//     }
//   }
//   bool isMyMessage({required String userId , required String senderId} ) =>    senderId==userId;
//
// }


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/firebase_message.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/view_model/chat_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/view_model/chat_state.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/firebase_message.dart';

class ChatViewModel extends Cubit<ChatState> {
  ChatViewModel() : super(ChatInitial());

  Future<void> loadMessages(String roomId) async {
    emit(ChatLoading());
    try {
      final messages = await FirebaseMessage.getMessages(roomId).first;
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError("Failed to load messages: ${e.toString()}"));
    }
  }

  Future<void> sendMessage(MessageModel message) async {
    try {
      await FirebaseMessage.sendMessage(message);
    } catch (e) {
      emit(ChatError("Failed to send message: ${e.toString()}"));
    }
  }
}
