import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/chat/room/view/create_room_screen.dart';
import 'package:smart_academy/chat/room/view/list_view_item.dart';
import 'package:smart_academy/chat/room/view_model/view_model_room.dart';

class MainChatScreen extends StatefulWidget {
  static const String routeName = "MainChatScreen";

  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  final viewModelRoom = RoomViewModel();

  @override
  void initState() {
    super.initState();
    viewModelRoom.getRoom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModelRoom,
      child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CreateRoomScreen.routeName)
                  .then((_) => viewModelRoom.getRoom());
            },
            backgroundColor: Colors.blue,
            shape: const CircleBorder(
                side: BorderSide(
              width: 3,
              color: Colors.white,
            )),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          body: const ListViewItem()),
    );
  }
}
