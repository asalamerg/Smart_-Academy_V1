

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/chat/chats/model/message_model.dart';
import 'package:smart_academy/chat/chats/view/chat_receive.dart';
import 'package:smart_academy/chat/chats/view_model/chat_state.dart';
import 'package:smart_academy/chat/chats/view_model/message_view_model.dart';
import 'package:smart_academy/shared/loading/loading.dart';
import 'package:smart_academy/shared/widget/text_field.dart';
import '../../../admin/feature_admin/authentication_admin/view_model/auth_bloc_admin.dart';
import '../../../parent/feature_parent/authentication_parent/view_model/bloc_auth_parent.dart';
import '../../../student/feature/authentication/view_model/auth_bloc.dart';
import '../../../teacher/feature_teacher/authentication_teacher/view_model/auth_bloc_teacher.dart';
import 'chat_send.dart';






class ChatScreen extends StatefulWidget {
  static const String routeName = "ChatScreen";
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final MessageViewModel viewModel;
  late String userId;
  late String userName;

  @override
  void initState() {
    super.initState();

    // الحصول على بيانات المستخدم الحالي من الـ Bloc Providers
    final teacher = context.read<AuthBlocTeacher>().modelTeacher;
    final admin = context.read<AuthBlocAdmin>().modelAdmin;
    final user = context.read<AuthBloc>().modelUser;
    final parent = context.read<AuthBlocParent>().modelParent;

    viewModel = MessageViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roomId = ModalRoute.of(context)!.settings.arguments as String;

      // تحديد هوية المستخدم الحالي
      userId = admin?.id ?? teacher?.id ?? user?.id ?? parent?.id ?? "user_${DateTime.now().millisecondsSinceEpoch}";
      userName = admin?.name ?? teacher?.name ?? user?.name ?? parent?.name ?? "مستخدم جديد";

      viewModel.initialize(roomId, userId, userName);
      viewModel.getMessageStream(roomId);
    });
  }

  bool isMyMessage(String senderId) {
    final teacher = context.read<AuthBlocTeacher>().modelTeacher;
    final admin = context.read<AuthBlocAdmin>().modelAdmin;
    final user = context.read<AuthBloc>().modelUser;
    final parent = context.read<AuthBlocParent>().modelParent;

    return admin?.id == senderId ||
        teacher?.id == senderId ||
        user?.id == senderId ||
        parent?.id == senderId;
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
            "الدردشة",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.blueAccent,
                  blurRadius: 4,
                  offset: Offset(4, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<MessageViewModel, ChatState>(
                    bloc: viewModel,
                    buildWhen :(p ,c)=> c is GetChatLoading || p is GetChatLoading ,
                    builder: (context, state) {
                      if (state is GetChatLoading) return const Loading();
                      if (state is GetChatError) return Center(child: Text(state.message));
                      if (state is GetChatSuccess) {
                        return StreamBuilder<List<MessageModel>>(
                          stream: state.streamMessage,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Loading();
                            }
                            if (snapshot.hasError) {
                              return const Center(child: Text('خطأ في تحميل الرسائل'));
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("بكل الحب وخالص الشكر نرحب بكم معنا في المجموعة"));
                            }

                            return ListView.builder(
                              reverse: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final message = snapshot.data![index];
                                final isMy = isMyMessage(message.senderId);
                                return isMy
                                    ? ChatSent(messageModel: message)
                                    : ChatReceive(messageModel: message);
                              },
                            );
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
                        controllerContent: viewModel.messageController,
                        ),
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: () => viewModel.sendMessage(),
                        icon: const Icon(Icons.send, size: 30, color: Colors.blue),
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