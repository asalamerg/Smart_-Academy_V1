import 'package:flutter/material.dart';
import 'package:smart_academy/shared/theme/apptheme.dart';
import 'package:smart_academy/student/feature/Notifications/view/notifications.dart';
import 'package:smart_academy/student/feature/chat/chat_screen_home.dart';
import 'package:smart_academy/student/feature/dashbord/view/dashbord.dart';
import 'package:smart_academy/student/feature/person/view/person.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int select = 0; // Track the selected index

  @override
  Widget build(BuildContext context) {
    // List of pages to navigate
    List<Widget> item = [
      Dashbord(), // Dashboard page
      const Chat(), // Chat page
      Notifications(), // Notifications page
      const Person(), // Person info page
    ];

    // Titles for each page
    List<String> pageTitles = [
      "Dashboard",
      "Chat",
      "Notifications",
      "Person",
    ];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text(
            pageTitles[
                select], // Display corresponding title based on selected page
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
        ),
        body: item[select], // Display selected page from the list

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: AppTheme.blu, // Blue color for selected item
          unselectedItemColor: Colors.black, // Black color for unselected items
          currentIndex: select, // Current selected index
          onTap: (index) {
            setState(() {
              select = index; // Update the selected page
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
                size: 35,
              ),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 35,
              ),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notification_important_rounded,
                size: 35,
              ),
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 35,
              ),
              label: "Person",
            ),
          ],
        ),
      ),
    );
  }
}
