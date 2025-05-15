import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/shared/theme/apptheme.dart';
import 'package:smart_academy/student/feature/authentication/model/firebaseFunctionUser.dart';
import 'package:smart_academy/student/feature/authentication/view/screen_ui/login/login.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_bloc.dart';

class Person extends StatefulWidget {
  const Person({super.key});

  @override
  State<Person> createState() => _PersonState();
}

class _PersonState extends State<Person> {
  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthBloc>(context).modelUser;
    final theme = Theme.of(context);
    final blueColor =
        AppTheme.blu; // استخدم لون AppTheme للتماشي مع الصفحة السابقة
    final lightBlue = AppTheme.blu.withOpacity(0.1);

    return Scaffold(
      backgroundColor: lightBlue,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: blueColor.withOpacity(0.15),
                  blurRadius: 25,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Header with gradient (مطابق للصفحة السابقة)
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        blueColor.withOpacity(0.85),
                        blueColor.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "My Profile",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Profile Avatar مع إضافة ظل وحجم أكبر قليلاً
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: blueColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            const AssetImage("assets/image/learing.jpg"),
                      ),
                    ),
                  ),
                ),

                // User Info Section مع زيادة المسافة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildInfoCard(
                        icon: Icons.person_outline,
                        label: "Name",
                        value: user?.name ?? "Not Available",
                        color: blueColor,
                      ),
                      const SizedBox(height: 18),
                      _buildInfoCard(
                        icon: Icons.badge_outlined,
                        label: "Student ID",
                        value: user?.numberId ?? "Not Available",
                        color: blueColor,
                      ),
                      const SizedBox(height: 35),
                    ],
                  ),
                ),

                // Logout Button مع تحسين التصميم ليشبه صفحة الـ HomeScreen
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _confirmLogout,
                      icon: const Icon(Icons.logout, size: 24),
                      label: Text(
                        "Logout",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 5,
                        shadowColor: blueColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.15), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: color.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                size: 52,
                color: AppTheme.blu,
              ),
              const SizedBox(height: 20),
              const Text(
                "Confirm Logout",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        logout();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() {
    FunctionFirebaseUser.logout();
    Navigator.of(context).pushReplacementNamed(Login.routeName);
  }
}
