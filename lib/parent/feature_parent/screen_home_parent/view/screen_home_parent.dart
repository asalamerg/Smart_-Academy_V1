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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashbordParent(),
    const MainChatScreen(),
    const PersonParent(),
  ];

  final List<String> _appBarTitles = [
    "Doshboard",
    "chat",
    "Profilae",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          _appBarTitles[_selectedIndex],
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 0
                      ? AppTheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: const Icon(Icons.dashboard),
              ),
              label: "Doshboard",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 1
                      ? AppTheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: const Icon(Icons.chat),
              ),
              label: "chat",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == 2
                      ? AppTheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: const Icon(Icons.person),
              ),
              label: "  Profilae",
            ),
          ],
        ),
      ),
    );
  }
}
