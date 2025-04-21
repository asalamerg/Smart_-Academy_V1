
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class  ChatReceive extends  StatelessWidget{
   ChatReceive({super.key});


  final String formattedTime = DateFormat.jm().format(DateTime.now()); // 5:08 PM

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: const BoxDecoration(
                color: Colors.grey ,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(0) , topRight: Radius.circular(10) ,bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10) ) ,
              ),
          
              child: const Text(" Receive Message " ,maxLines: 5 ,overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 20  , fontWeight: FontWeight.w400),) ),
        ),

        //SizedBox(width: MediaQuery.of(context).size.width * 0.30,),


        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(formattedTime ,style: const TextStyle(fontSize: 15 ,fontWeight:FontWeight.w400 ),)),

      ],);
  }
}