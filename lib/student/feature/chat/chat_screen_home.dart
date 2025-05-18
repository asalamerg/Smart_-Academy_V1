// //
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // import 'room_screen.dart';
// //
// // class Chat extends StatelessWidget{
// //   @override
// //   Widget build(BuildContext context) {
// //    return Scaffold(
// //      body: Column(children: [
// //        RoomScreen(),
// //        // FloatingActionButton(onPressed: (){},child: Icon(Icons.add ,size: 40 ,color: Colors.white,),
// //        //   backgroundColor: Colors.blue,
// //        //   shape: CircleBorder(side: BorderSide(width: 3,color: Colors.white)),
// //        //
// //        // ),
// //
// //      ],),
// //        // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked
// //    );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_academy/student/feature/chat/room/view_model/view_model_room.dart';
//
// import 'room/view/create_room_screen.dart';
// import 'room/view/room_screen.dart';
//
//
//
//
// class Chat extends StatefulWidget {
//   static const routeName="chat";
//
//   const Chat({super.key});
//
//   @override
//   State<Chat> createState() => _ChatState();
// }
//
// class _ChatState extends State<Chat> {
//   final viewModel=ViewModelRoom() ;
//
//   @override
//   void initState() {
//     super.initState();
//     viewModel.getRoomViewModel();
//   }
//
//
//   @override
//
//   @override
//
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (_) => viewModel,
//     child: Scaffold(
//     body: const RoomScreen(),
//
//
//     floatingActionButton: FloatingActionButton(
//     onPressed: () => Navigator.of(context).pushNamed(CreateRoomScreen.routeName).then((value)=>viewModel.getRoomViewModel()),
//
//     backgroundColor: Colors.blue,
//     shape: const CircleBorder(side: BorderSide(width: 3, color: Colors.white)),
//     child: const Icon(Icons.add, size: 40, color: Colors.white),
//     ) ,
//
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//
//
//     ));
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/student/feature/chat/room/view_model/view_model_room.dart';

import 'room/view/create_room_screen.dart' as create;
import 'room/view/room_screen.dart' as room;

class Chat extends StatefulWidget {
  static const routeName = "chat";

  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final viewModel = ViewModelRoom();

  @override
  void initState() {
    super.initState();
    viewModel.loadRooms(); // تأكد أن هذه الدالة موجودة في ViewModelRoom
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => viewModel,
      child: Scaffold(
        body: const room.RoomScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .pushNamed(create.RoomScreen.routeName)
              .then((value) => viewModel.loadRooms()),
          backgroundColor: Colors.blue,
          shape: const CircleBorder(
              side: BorderSide(width: 3, color: Colors.white)),
          child: const Icon(Icons.add, size: 40, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}
