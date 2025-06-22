import 'package:flutter/material.dart';
import 'package:smart_academy/admin/feature_admin/dashbord_admin/view/dashbord_admin.dart';
import 'package:smart_academy/admin/feature_admin/person_admin/view/person_admin.dart';
import 'package:smart_academy/chat/main_chat_screen.dart';
import 'package:smart_academy/shared/theme/apptheme.dart';

class ScreenHomeAdmin extends StatefulWidget {
  static const String routeName = "ScreenHomeAdmin";

  const ScreenHomeAdmin({super.key});

  @override
  State<ScreenHomeAdmin> createState() => _ScreenHomeAdminState();
}

class _ScreenHomeAdminState extends State<ScreenHomeAdmin> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashbordAdmin(),
    const MainChatScreen(),
    const PersonAdmin(),
  ];

  final List<String> _appBarTitles = ["Dashbord ", "Caht", "Personal"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: _screens[_selectedIndex],
    );
  }

  Widget _buildBottomNavBar() {
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(1)),
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
              label: "Dashbord",
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
              label: "Chat",
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
              label: "Personal ",
            ),
          ],
        ),
      ),
    );
  }
}
