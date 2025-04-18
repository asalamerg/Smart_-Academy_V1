//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'room_screen.dart';
//
// class Chat extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//    return Scaffold(
//      body: Column(children: [
//        RoomScreen(),
//        // FloatingActionButton(onPressed: (){},child: Icon(Icons.add ,size: 40 ,color: Colors.white,),
//        //   backgroundColor: Colors.blue,
//        //   shape: CircleBorder(side: BorderSide(width: 3,color: Colors.white)),
//        //
//        // ),
//
//      ],),
//        // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked
//    );
//   }
// }
import 'package:flutter/material.dart';
import 'package:smart_academy/feature/chat/presentation/create_room_screen.dart';

import 'room_screen.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  const RoomScreen(),


    floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.of(context).pushNamed(CreateRoomScreen.routeName);
    },
    backgroundColor: Colors.blue,
    shape: const CircleBorder(side: BorderSide(width: 3, color: Colors.white)),
    child: const Icon(Icons.add, size: 40, color: Colors.white),
    ) ,

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,


    );
  }
}