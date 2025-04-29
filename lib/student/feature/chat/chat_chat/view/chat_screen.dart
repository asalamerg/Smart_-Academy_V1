
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_academy/shared/error/error.dart';
import 'package:smart_academy/shared/loading/loading_indicator.dart';
import 'package:smart_academy/shared/widget/text_field.dart';
import 'package:smart_academy/student/feature/authentication/model/model_user.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_bloc.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/view/chat_receive.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/view/chat_send.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/view_model/chat_state.dart';
import 'package:smart_academy/student/feature/chat/chat_chat/view_model/chat_view_model.dart';
import 'package:smart_academy/student/feature/chat/room/model/room_model.dart';



class ChatHome extends StatefulWidget {
  static const String routeName = "chat/chat";

  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}


class _ChatHomeState extends State<ChatHome> {
  final viewModel = ChatViewModel();
  late final RoomModel room;
  late final ModelUser userModel;

   TextEditingController controllerContent = TextEditingController();
   List<MessageModel> message=[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments;
    if (args is RoomModel) {
      room = args;
      viewModel.getMessageViewModelStream(room.id);
    } else {
      throw Exception("البيانات المرسلة ليست من نوع RoomModel");
    }

    userModel = BlocProvider.of<AuthBloc>(context).modelUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(

        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text("Message", style: Theme.of(context).textTheme.displayLarge,),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,

          margin: const EdgeInsets.symmetric(vertical:  30, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 2, color: Colors.black),
          ),

          child: Column(

            children: [
              Expanded(
                child: BlocBuilder<ChatViewModel, ChatState>(
                  bloc: viewModel,
                  buildWhen: (previous, current) =>
                  current is GetChatStateLoading ||
                      previous is GetChatStateLoading,
                  builder: (context, state) {
                    if (state is GetChatStateLoading) {
                      return const LoadingIndicator();
                    } else if (state is GetChatStateError) {
                      return ErrorIndicator(message: state.messageError);
                    } else if (state is GetChatStateSuccess) {
                      return StreamBuilder(
                        stream: state.messageStream,
                        builder: (context, snapshot) {

                           if(snapshot.hasData){
                             message = snapshot.data!.reversed.toList() ;
                           }

                          return ListView.builder(
                            reverse: true,
                            itemCount: message.length,
                            itemBuilder: (context, index) {
                              final messages = message[index];
                              final isMessage = viewModel.isMyMessage(
                                senderId: messages.sentId,
                                userId: userModel.id,

                              );
                              return isMessage
                                  ? ChatSent(messageModel: messages)
                                  : ChatReceive(messageModel: messages);
                            },
                          );
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Container(

                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Row(
                  children: [
                    DefaultTextField(
                        controllerContent: controllerContent),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: sentMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        fixedSize: const Size(140, 55),
                      ),
                      child: const Row(
                        children: [
                          Text("Sent", style: TextStyle(fontSize: 20)),
                          SizedBox(width: 20),
                          Icon(Icons.send, size: 30),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sentMessage() {
    if(controllerContent.text.isEmpty) return ;
        final textC=controllerContent.text;
        controllerContent.clear();

    viewModel.sentMessageViewModel(
      MessageModel(
        roomId: room.id,
        sentId: userModel.id,
        dateTime: DateTime.now(),
        content: textC,
        receiveName: userModel.name,
      ),

    );


  }



}



