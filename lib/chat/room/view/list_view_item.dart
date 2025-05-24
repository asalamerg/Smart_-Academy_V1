import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, WatchContext;
import 'package:smart_academy/chat/room/view/item_room.dart';
import 'package:smart_academy/chat/room/view_model/status_room.dart';
import 'package:smart_academy/chat/room/view_model/view_model_room.dart';
import 'package:smart_academy/shared/error/error.dart';
import 'package:smart_academy/shared/loading/loading_indicator.dart';

class ListViewItem extends StatelessWidget {



  const ListViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModelRoom = context.watch<RoomViewModel>(); // بدلًا من إنشائه

    return BlocBuilder<RoomViewModel,StatusRoom>(
      builder: (context, state) {
        if(state is GetRoomLoading){return const LoadingIndicator();}
        else if(state is GetRoomError){return ErrorIndicator(message: state.message,);}
        else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) =>
                ItemRoom(roomModel: viewModelRoom.rooms[index]),
            itemCount: viewModelRoom.rooms.length,);
        }},
    );
  }
}