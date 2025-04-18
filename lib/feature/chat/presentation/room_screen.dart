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
import 'package:smart_academy/feature/chat/presentation/room_item.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => const RoomItem(),
            itemCount: 6,
          ),
        ),
      ),
    );
  }
}