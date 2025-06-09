import 'package:flutter/material.dart';
import 'package:smart_academy/chat/main_chat_screen.dart';
import 'package:smart_academy/parent/feature_parent/dashbord_parent/view/dashbord_parent.dart';
import 'package:smart_academy/parent/feature_parent/person_parent/view/person_parent.dart';
import 'package:smart_academy/shared/theme/apptheme.dart';

class ScreenHomeParent extends StatefulWidget {
  static const String routeName = "ScreenHomeParent";
  const ScreenHomeParent({super.key});

  @override
  State<ScreenHomeParent> createState() => _ScreenHomeParentState();
}

class _ScreenHomeParentState extends State<ScreenHomeParent> {
  int select = 0;
  List<Widget> item = [
    DashbordParent(),
    MainChatScreen(),
    PersonParent(),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/image/background.png"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text(
            item[select].toString(),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
        ),
        body: item[select],

        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedItemColor: AppTheme.blu,
            unselectedItemColor: Colors.black,
            currentIndex: select,
            onTap: (index) {
              select = index;
              setState(() {});
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                  size: 35,
                ),
                label: "DashBord",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  size: 35,
                ),
                label: "chat",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  label: "person"),
            ]),
        // appBar: AppBar(title: Text("Welcome"),),
      ),
    );
  }
}
