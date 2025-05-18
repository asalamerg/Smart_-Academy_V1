//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_academy/shared/error/error.dart';
// import 'package:smart_academy/shared/loading/loading_indicator.dart';
// import 'package:smart_academy/shared/widget/text_field.dart';
// import 'package:smart_academy/student/feature/authentication/model/model_user.dart';
// import 'package:smart_academy/student/feature/authentication/view_model/auth_bloc.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/model/message_model.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/view/chat_receive.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/view/chat_send.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/view_model/chat_state.dart';
// import 'package:smart_academy/student/feature/chat/chat_chat/view_model/chat_view_model.dart';
// import 'package:smart_academy/student/feature/chat/room/model/room_model.dart';
//
// class ChatHome extends StatefulWidget {
//   static const String routeName = "chat/chat";
//
//   const ChatHome({super.key});
//
//   @override
//   State<ChatHome> createState() => _ChatHomeState();
// }
//
// class _ChatHomeState extends State<ChatHome> {
//   late final RoomModel _room;
//   late final ModelUser _user;
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   late ChatViewModel _viewModel;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _viewModel = ChatViewModel(); // Initialize here
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isInitialized) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is RoomModel) {
//         _room = args;
//         _user = BlocProvider.of<AuthBloc>(context).modelUser!;
//         _viewModel.loadMessages(_room.id);
//         _isInitialized = true;
//       } else {
//         throw Exception("Invalid argument type: Expected RoomModel");
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _viewModel.close(); // Important for BLoC
//     super.dispose();
//   }
//
//   Future<void> _sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;
//
//     final message = MessageModel(
//       roomId: _room.id,
//       sentId: _user.id,
//       receiveName: _room.name,
//       dateTime: DateTime.now(),
//       content: text,
//     );
//
//     _messageController.clear();
//     FocusScope.of(context).unfocus();
//
//     try {
//       await _viewModel.sendMessage(message);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           _scrollController.animateTo(
//             0,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send message: ${e.toString()}')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _viewModel,
//       child: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/image/background.png"),
//             fit: BoxFit.cover, // Changed from fill to cover for better display
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             title: Text(_room.name, style: Theme.of(context).textTheme.displayLarge),
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//           ),
//           body: SafeArea(
//             child: Container(
//               margin: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.9), // Added opacity
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(width: 2, color: Colors.black),
//               ),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: BlocBuilder<ChatViewModel, ChatState>(
//                       bloc: _viewModel,
//                       builder: (context, state) {
//                         if (state is ChatLoading) {
//                           return const Center(child: LoadingIndicator());
//                         } else if (state is ChatError) {
//                           return Center(child: ErrorIndicator(message: state.message));
//                         } else if (state is ChatLoaded) {
//                           final messages = state.messages;
//
//                           if (messages.isEmpty) {
//                             return const Center(
//                               child: Text(
//                                 "لا توجد رسائل حتى الآن.",
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             );
//                           }
//
//                           return ListView.builder(
//                             controller: _scrollController,
//                             reverse: true,
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             itemCount: messages.length,
//                             itemBuilder: (context, index) {
//                               final message = messages[index];
//                               final isMine = message.sentId == _user.id;
//
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 4),
//                                 child: isMine
//                                     ? ChatSent(messageModel: message)
//                                     : ChatReceive(messageModel: message),
//                               );
//                             },
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: DefaultTextField(
//                             controllerContent: _messageController,
//                             hintText: "اكتب رسالة...",
//                             onSubmitted: (_) => _sendMessage(),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         ElevatedButton(
//                           onPressed: _sendMessage,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             foregroundColor: Colors.white,
//                             minimumSize: const Size(60, 56),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           child: const Icon(Icons.send, size: 28),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


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
  late final RoomModel _room;
  late final ModelUser _user;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatViewModel _viewModel;
  bool _isRoomInitialized = false;

  @override
  void initState() {
    super.initState();
    _viewModel = BlocProvider.of<ChatViewModel>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isRoomInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is RoomModel) {
        final authBloc = BlocProvider.of<AuthBloc>(context);
        final currentUser = authBloc.modelUser;

        if (currentUser == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("خطأ: لم يتم العثور على بيانات المستخدم")),
            );
            Navigator.pop(context);
          });
          return;
        }

        _room = args;
        _user = currentUser;
        _viewModel.loadMessages(_room.id);
        _isRoomInitialized = true;
      } else {
        throw Exception("Invalid argument type: Expected RoomModel");
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = MessageModel(
      roomId: _room.id,
      sentId: _user.id,
      receiveName: _room.name,
      dateTime: DateTime.now(),
      content: text,
    );

    _messageController.clear();
    FocusScope.of(context).unfocus();

    await _viewModel.sendMessage(message);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            _isRoomInitialized ? _room.name : '',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: Colors.black),
            ),
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatViewModel, ChatState>(
                    bloc: _viewModel,
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const LoadingIndicator();
                      } else if (state is ChatError) {
                        return ErrorIndicator(message: state.message);
                      } else if (state is ChatLoaded) {
                        final messages = state.messages;

                        if (messages.isEmpty) {
                          return const Center(child: Text("لا توجد رسائل حتى الآن."));
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMine = message.sentId == _user.id;

                            return isMine
                                ? ChatSent(messageModel: message)
                                : ChatReceive(messageModel: message);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DefaultTextField(
                          controllerContent: _messageController,
                          hintText: "اكتب رسالة...",
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(60, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
