import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_academy/shared/error/error.dart';
import 'package:smart_academy/shared/loading/loading.dart';
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
import 'package:smart_academy/student/feature/chat/room/view_model/status_room.dart';
import 'package:smart_academy/student/feature/chat/room/view_model/view_model_room.dart';
import 'room_item.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late ViewModelRoom viewModel;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      viewModel = BlocProvider.of<ViewModelRoom>(context);
      // viewModel.getRoomViewModel();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocConsumer<ViewModelRoom, StatusRoom>(
            listener: (context, state) {
              if (state is DeleteRoomSuccess) {
                setState(() {}); // تحديث الواجهة
              }
              if (state is DeleteRoomError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطأ أثناء الحذف: ${state.message}')),
                );
              }
            },
            builder: (context, state) {
              if (state is GetRoomLoading || state is DeleteRoomLoading) {
                return const Loading();
              } else if (state is GetRoomError) {
                return ErrorIndicator(message: state.message);
              } else {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: viewModel.rooms.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ChatHome.routeName,
                        arguments: viewModel.rooms[index],
                      );
                    },
                    child: RoomItem(roomModel: viewModel.rooms[index]),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is RoomModel) {
        room = args;
        viewModel.getMessageViewModelStream(room.id);
      } else {
        throw Exception("البيانات المرسلة ليست من نوع RoomModel");
      }

      userModel = BlocProvider.of<AuthBloc>(context).modelUser!;
    });
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
        appBar: AppBar(
          title: Text(
            "Message ",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          foregroundColor: Colors.white,
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 2, color: Colors.black),
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatViewModel, ChatState>(
                  bloc: BlocProvider.of<ChatViewModel>(context),
                  builder: (context, state) {
                    if (state is GetChatStateLoading) {
                      return const LoadingIndicator();
                    } else if (state is GetChatStateError) {
                      return ErrorIndicator(message: state.messageError);
                    } else if (state is GetChatStateSuccess) {
                      return StreamBuilder(
                        stream: state.messageStream,
                        builder: (context, snapshot) {
                          final message = snapshot.data ?? [];
                          return ListView.builder(
                            itemCount: message.length,
                            itemBuilder: (context, index) {
                              final messages = message[index];
                              final isMessage =
                                  BlocProvider.of<ChatViewModel>(context)
                                      .isMyMessage(
                                userId: userModel.id,
                                senderId: messages.id,
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
                    DefaultTextField(controllerContent: controllerContent),
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
    BlocProvider.of<ChatViewModel>(context).sentMessageViewModel(
      MessageModel(
        roomId: room.id,
        sentId: userModel.id,
        dateTime: DateTime.now(),
        content: controllerContent.text,
        receiveName: userModel.name,
      ),
    );
  }
}


// class RoomScreen extends StatefulWidget {
//   const RoomScreen({super.key});
//
//   @override
//   State<RoomScreen> createState() => _RoomScreenState();
// }
//
// class _RoomScreenState extends State<RoomScreen> {
//
//   late ViewModelRoom viewModel;
//   bool _isInit = true;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_isInit) {
//       viewModel = BlocProvider.of<ViewModelRoom>(context);
//       viewModel.getRoomViewModel();
//       _isInit = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: BlocConsumer<ViewModelRoom, StatusRoom>(
//             listener: (context, state) {
//               if (state is DeleteRoomSuccess) {
//                 setState(() {}); // تحديث الواجهة
//               }
//               if (state is DeleteRoomError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('خطأ أثناء الحذف: ${state.message}')),
//                 );
//               }
//             },
//             builder: (context, state) {
//               if (state is GetRoomLoading || state is DeleteRoomLoading) {
//                 return const Loading();
//               } else if (state is GetRoomError) {
//                 return ErrorIndicator(message: state.message);
//               } else {
//                 return InkWell(
//                   onTap: (){
//                     Navigator.of(context).pushNamed(ChatHome.routeName  ,arguments: viewModel.rooms[index]    );
//                   },
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.8,
//                       mainAxisSpacing: 2,
//                       crossAxisSpacing: 2,
//                     ),
//                     itemCount: viewModel.rooms.length,
//                     itemBuilder: (context, index) =>
//                         RoomItem(roomModel: viewModel.rooms[index]),
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//
//     );
//   }
//
// }
//