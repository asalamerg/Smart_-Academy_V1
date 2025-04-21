
import 'package:flutter/material.dart';
import 'package:smart_academy/feature/chat/chat_chat/view/chat_receive.dart';
import 'package:smart_academy/feature/chat/chat_chat/view/chat_send.dart';

class ChatHome extends StatelessWidget{
  static const  String routeName="chat/chat";

  const ChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Chat ",style: Theme.of(context).textTheme.displayLarge,),foregroundColor: Colors.white,),
        body:  Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2,color: Colors.black)
          ),
          child:  Column(children: [
          
              Expanded(child: ListView.builder(itemBuilder: (context,index)=>ChatSent(), itemCount: 10,)), 

            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              child: Row(children: [
                 Flexible(
                  flex: 2,
                  child:TextField(
                    decoration: InputDecoration(
                      hintText: "رسالتك هنا...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    textDirection: TextDirection.rtl,
                    maxLines: 3,
                    minLines: 1,
                  )
                              ),

                const SizedBox(width: 5,),

                ElevatedButton(onPressed: (){} ,style: ElevatedButton.styleFrom(backgroundColor: Colors.blue ,foregroundColor:  Colors.white ,fixedSize: Size(140, 55)),
                    child:const Row(children: [Text("Sent",style: TextStyle(fontSize: 20),),SizedBox(width: 20,) ,Icon(Icons.send,size: 30,)],))
              ],),
            ),


          ],),
        ),
      ),
    );
  }
}