
import 'package:flutter/material.dart';

class RoomItem extends StatelessWidget{
  const RoomItem({super.key});

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
      child: Column(children: [
        Image(image:const AssetImage("assets/image/movies.png")
          ,height: MediaQuery.of(context).size.height * 0.12,
          width:MediaQuery.of(context).size.width * 0.12 , ),
        const Text("The  Movies Zoom  " ,style: TextStyle(fontSize: 16,fontWeight:FontWeight.w600 ,color: Colors.black ),),
        const Text(" 17/4/2025" ,style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400 ,color: Colors.blue )),
      ],),
    );
  }
}
