

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/chat/chats/model/firebase_message.dart';
import 'package:smart_academy/chat/chats/model/message_model.dart';
import 'package:smart_academy/chat/chats/view_model/chat_state.dart';
import 'package:smart_academy/chat/room/model/room_model.dart';






class MessageViewModel extends Cubit<ChatState> {
  final TextEditingController messageController = TextEditingController();
  RoomModel? roomModel;
  String? currentUserId;
  String? currentUserName;

  MessageViewModel() : super(ChatInitial());

  void initialize(String roomId, String userId, String userName) {
    roomModel = RoomModel(id: roomId, name: '', description: '');
    currentUserId = userId;
    currentUserName = userName;
  }

  Future<void> sendMessage() async {
    if (messageController.text.isEmpty) return;
    if (roomModel == null || currentUserId == null || currentUserName == null) {
      emit(SentChatError('بيانات المرسل غير مكتملة'));
      return;
    }

    emit(SentChatLoading());
    try {
      final message = MessageModel(
        dateTime: DateTime.now(),
        content: messageController.text,
        roomId: roomModel!.id,
        senderId: currentUserId!,
        senderName: currentUserName!, // سيستخدم الاسم الحقيقي للمستخدم
      );

      await FirebaseMessage.insertMessageToRoom(message);
      messageController.clear();
      emit(SentChatSuccess());
    } catch (e) {
      emit(SentChatError('فشل إرسال الرسالة: ${e.toString()}'));
      debugPrint('❌ Error in sendMessage: $e');
    }
  }

  Future<void> getMessageStream(String roomId) async {
    emit(GetChatLoading());
    try {
      if (roomId.isEmpty) {
        throw Exception('معرف الغرفة فارغ');
      }

      final streamMessage = FirebaseMessage.getMessage(roomId);
      emit(GetChatSuccess(streamMessage));
    } catch (e) {
      emit(GetChatError('فشل تحميل الرسائل: ${e.toString()}'));
      debugPrint('❌ Error in getMessageStream: $e');
    }
  }

  bool isMyMessage(String senderId) {
    return currentUserId == senderId;


  }



}