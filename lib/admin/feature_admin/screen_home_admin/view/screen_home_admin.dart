
import 'package:flutter/material.dart';
import 'package:smart_academy/admin/feature_admin/dashbord_admin/view/dashbord_admin.dart';
import 'package:smart_academy/admin/feature_admin/person_admin/view/person_admin.dart';
import 'package:smart_academy/chat/main_chat_screen.dart';
import 'package:smart_academy/shared/theme/apptheme.dart';

class ScreenHomeAdmin extends StatefulWidget{
  static const  String routeName="ScreenHomeAdmin";

   const ScreenHomeAdmin({super.key});

  @override
  State<ScreenHomeAdmin> createState() => _ScreenHomeAdminState();

}

class _ScreenHomeAdminState extends State<ScreenHomeAdmin> {
  int select=0;
  List<Widget> item=[
    DashbordAdmin(),
    MainChatScreen(),
    const PersonAdmin()
  ];
  @override
  Widget build(BuildContext context) {
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
              BottomNavigationBarItem(icon: Icon(Icons.chat,size: 35,),label: "chat",),
              BottomNavigationBarItem(icon: Icon(Icons.person ,size: 35,),label: "person"),
            ]),
        // appBar: AppBar(title: Text("Welcome"),),

      ),
    );
  }
}