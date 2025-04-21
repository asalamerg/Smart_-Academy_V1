// import 'package:flutter/material.dart';
// import 'package:smart_academy/feature/chat/presentation/room_item.dart';
//
// class RoomScreen extends StatelessWidget {
//   const RoomScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Expanded(
//               child: GridView.builder(
//                 shrinkWrap: true, // ضروري عند استخدام SingleChildScrollView
//                 physics: const NeverScrollableScrollPhysics(), // تعطيل التمرير الداخلي
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//                 itemBuilder: (context, index) => RoomItem(),
//                 itemCount: 6,
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       // ✅ هذا هو المكان الصحيح للزر
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Icon(Icons.add, size: 40, color: Colors.white),
//         backgroundColor: Colors.blue,
//         shape: CircleBorder(side: BorderSide(width: 3, color: Colors.white)),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:smart_academy/feature/chat/presentation/room_item.dart';
//
// class RoomScreen extends StatelessWidget {
//   const RoomScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1,
//               ),
//               itemBuilder: (context, index) => const RoomItem(),
//               itemCount: 6,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.add, size: 40, color: Colors.white),
//         backgroundColor: Colors.blue,
//         shape: const CircleBorder(side: BorderSide(width: 3, color: Colors.white)),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/feature/chat/room/view_model/status_room.dart';
import 'package:smart_academy/feature/chat/room/view_model/view_model_room.dart';
import 'package:smart_academy/shared/error/error.dart';
import 'package:smart_academy/shared/loading/loading.dart';

import 'room_item.dart';

class RoomScreen extends StatefulWidget {

    const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late ViewModelRoom viewModel;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      viewModel = BlocProvider.of<ViewModelRoom>(context);
      viewModel.getRoomViewModel();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (context)=>viewModel,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<ViewModelRoom,StatusRoom>(builder: (context,state){
              if(state is GetRoomLoading){return const Loading();}
              else if (state is GetRoomError){return ErrorIndicator(message: state.message,);}


            else {
           return    GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) =>  RoomItem(roomModel: viewModel.rooms[index],),
                itemCount: viewModel.rooms.length );}}
              ),



    )))
    );
  }
}