import 'package:flutter/material.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view/login_admin.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view/login_parent.dart';
import 'package:smart_academy/student/feature/authentication/view/screen_ui/login/login.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view/login_teacher.dart';

class SelectCategory extends StatefulWidget {
  static const String routeName = "SelectCategory";

  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.blue.shade700;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 4,
        centerTitle: true,
        title: Text(
          'Welcome to Smart Academy',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Icon(
                          Icons.school,
                          size: 64,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          'Smart Academy',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'نحو مستقبل تعليمي أفضل وأكثر تميزًا',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.blue.shade900,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Category Buttons
                        GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 2 : 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 3,
                          ),
                          children: [
                            _buildCategoryButton(
                              context: context,
                              label: 'طالب',
                              icon: Icons.school,
                              color: Colors.blue.shade100,
                              textColor: Colors.blue.shade900,
                              route: Login.routeName,
                            ),
                            _buildCategoryButton(
                              context: context,
                              label: 'معلم',
                              icon: Icons.person,
                              color: Colors.blue.shade700,
                              textColor: Colors.white,
                              route: LoginTeacher.routeName,
                            ),
                            _buildCategoryButton(
                              context: context,
                              label: 'ولي أمر',
                              icon: Icons.family_restroom,
                              color: Colors.blue.shade100,
                              textColor: Colors.blue.shade900,
                              route: LoginParent.routeName,
                            ),
                            _buildCategoryButton(
                              context: context,
                              label: 'إداري',
                              icon: Icons.admin_panel_settings,
                              color: Colors.blue.shade700,
                              textColor: Colors.white,
                              route: LoginAdmin.routeName,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required String route,
  }) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: () => _navigateTo(context, route),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.blue.shade100, width: 1),
        ),
        elevation: 4,
        shadowColor: Colors.blue.shade700.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
