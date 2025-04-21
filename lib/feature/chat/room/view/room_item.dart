
import 'package:flutter/material.dart';
import 'package:smart_academy/feature/chat/room/model/room_model.dart';

class RoomItem extends StatelessWidget{
 final RoomModel roomModel ;
   const RoomItem({super.key ,required this.roomModel});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white ,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
       border: Border.all(width: 1 ,color: Colors.black),

      ),
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Image(image:const AssetImage("assets/image/chat.png")
          ,height: MediaQuery.of(context).size.height * 0.15,
          width:MediaQuery.of(context).size.width * 0.25 ,
          fit: BoxFit.fill,
        ),
         Text(roomModel.name ,style:const TextStyle(fontSize: 16,fontWeight:FontWeight.w600 ,color: Colors.black ),),

         Text(roomModel.description ,maxLines: 3, overflow: TextOverflow.ellipsis , style: const TextStyle(fontSize: 14,fontWeight:FontWeight.w400 ,color: Colors.blue )

         ),
      ],),
    );
  }
}
