import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_academy/feature/chat/room/model/room_model.dart';
import 'package:smart_academy/feature/chat/room/view_model/view_model_room.dart';

class RoomItem extends StatelessWidget {
  final RoomModel roomModel;

  const RoomItem({super.key, required this.roomModel});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(roomModel.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          BlocProvider.of<ViewModelRoom>(context).deleteRoomViewModel(roomModel.id);
        }),
        children: [
          SlidableAction(
            onPressed: (context) {
              BlocProvider.of<ViewModelRoom>(context).deleteRoomViewModel(roomModel.id);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(25),
            padding: const EdgeInsets.all(10),

          ),
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        padding: const EdgeInsets.only(left: 20 ,right: 20 ,bottom: 10  ),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          border: Border.all(width: 1, color: Colors.black),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/image/chat.png",
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.25,
              fit: BoxFit.fill,
            ),
            Text(
              roomModel.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            Text(
              roomModel.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w400, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
