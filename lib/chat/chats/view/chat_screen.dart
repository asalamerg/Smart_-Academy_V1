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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final teacher = context.read<AuthBlocTeacher>().modelTeacher;
    final admin = context.read<AuthBlocAdmin>().modelAdmin;
    final user = context.read<AuthBloc>().modelUser;
    final parent = context.read<AuthBlocParent>().modelParent;

    viewModel = MessageViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roomId = ModalRoute.of(context)!.settings.arguments as String;

      userId = admin?.id ??
          teacher?.id ??
          user?.id ??
          parent?.id ??
          "user_${DateTime.now().millisecondsSinceEpoch}";
      userName = admin?.name ??
          teacher?.name ??
          user?.name ??
          parent?.name ??
          "مستخدم جديد";

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "chat",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BlocBuilder<MessageViewModel, ChatState>(
                    bloc: viewModel,
                    buildWhen: (p, c) =>
                        c is GetChatLoading || p is GetChatLoading,
                    builder: (context, state) {
                      if (state is GetChatLoading) return const Loading();
                      if (state is GetChatError)
                        return Center(child: Text(state.message));
                      if (state is GetChatSuccess) {
                        return StreamBuilder<List<MessageModel>>(
                          stream: state.streamMessage,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Loading();
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error_outline,
                                          size: 48, color: Colors.red[400]),
                                      const SizedBox(height: 16),
                                      const Text('حدث خطأ في تحميل المحادثة',
                                          style: TextStyle(fontSize: 16)),
                                    ]),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble_outline,
                                        size: 48, color: Colors.blue[300]),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "مرحباً بك في المحادثة",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "ابدأ المحادثة بإرسال رسالة جديدة",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients) {
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final message = snapshot.data![index];
                                final isMy = isMyMessage(message.senderId);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: isMy
                                      ? ChatSent(messageModel: message)
                                      : ChatReceive(messageModel: message),
                                );
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: viewModel.messageController,
                                  decoration: const InputDecoration(
                                    hintText: "اكتب رسالة...",
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  maxLines: 3,
                                  minLines: 1,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (_) => viewModel.sendMessage(),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_file,
                                    color: Colors.grey[600]),
                                onPressed: () {
                                  // Add attachment functionality
                                },
                              ),
                            ],
                          ),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.blue[600]!, Colors.blue[400]!],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    child: IconButton(
                      onPressed: () => viewModel.sendMessage(),
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
