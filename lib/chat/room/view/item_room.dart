
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_academy/chat/chats/view/chat_screen.dart';
import 'package:smart_academy/chat/room/model/room_model.dart';
import 'package:smart_academy/chat/room/view_model/view_model_room.dart';

class ItemRoom extends StatelessWidget{

  RoomModel roomModel ;
  ItemRoom({super.key, required this.roomModel});
  @override

  Widget build(BuildContext context) {

    final viewModelRoom = context.read<RoomViewModel>();
    return InkWell(
      onTap: (){Navigator.of(context).pushNamed(ChatScreen.routeName ,arguments: roomModel.id);},
      child: Slidable(
        startActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            onPressed: (D){
              viewModelRoom.deleteRoom(roomModel.id);

            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            spacing: 5,
            borderRadius: BorderRadius.circular(25),
          ),
        ]),
        child: Container(
          height:MediaQuery.of(context).size.height * 0.60 ,
            width: MediaQuery.of(context).size.width * 0.60,

         margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
           decoration: BoxDecoration(
               boxShadow: const [
                 BoxShadow(
                   color: Colors.blueGrey,
                   blurRadius: 4,
                   offset: Offset(4, 8), // Shadow position
                 ),
               ],
             color: Colors.white60,
                 borderRadius: BorderRadius.circular(25) ,
                 border: Border.all(width: 2 ,color: Colors.blue)
           ),

          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset("assets/image/chat.png" ,height:  MediaQuery.of(context).size.height * 0.20 ,
               width: MediaQuery.of(context).size.width * 0.30  , fit: BoxFit.fill,),

            Text(roomModel.name),
            Text(roomModel.description),
          ],),
        ),
      ),
    );
  }
}