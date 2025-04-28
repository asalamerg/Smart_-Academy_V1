
import 'package:flutter/material.dart';

import 'package:smart_academy/shared/theme/apptheme.dart';
import 'package:smart_academy/student/feature/Notifications/view/notifications.dart';
import 'package:smart_academy/student/feature/chat/chat_screen_home.dart';
import 'package:smart_academy/student/feature/dashbord/view/dashbord.dart';
import 'package:smart_academy/student/feature/person/view/person.dart';

class HomeScreen extends StatefulWidget{
static const  String routeName="home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  int select=0;
  @override
  Widget build(BuildContext context) {
    List<Widget> item=[
      Dashbord(),
      const Chat(),
      Notifications(),
      const Person(),
    ];
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/image/background.png"),fit: BoxFit.fill),
      ),
      child: Scaffold(
         appBar: AppBar(  leading: Container() ,title: Text(item[select].toString() ,style: Theme.of(context).textTheme.displayLarge,),centerTitle: true,),
          body: item[select],

        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: AppTheme.blu,
            unselectedItemColor: Colors.black,

            currentIndex: select,

            onTap: (index){
              select=index;
              setState(() {

              });
            },
            items: const [

              BottomNavigationBarItem(icon: Icon(Icons.dashboard,size: 35,),label: "DashBord",),
              BottomNavigationBarItem(icon: Icon(Icons.chat,size: 35,),label: "chat"),
              BottomNavigationBarItem(icon: Icon(Icons.notification_important_rounded,size: 35,),label: "Notifications"),
              BottomNavigationBarItem(icon: Icon(Icons.person ,size: 35,),label: "person"),
        ]),
        // appBar: AppBar(title: Text("Welcome"),),

      ),
    );
  }
}