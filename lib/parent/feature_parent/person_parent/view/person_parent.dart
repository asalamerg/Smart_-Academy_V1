import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/model/firebase_parent.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/model/model_parent.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view/login_parent.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/bloc_auth_parent.dart';
import 'package:smart_academy/student/feature/authentication/Controller/StudentsController.dart';
import 'package:smart_academy/student/feature/authentication/model/model_user.dart';

class PersonParent extends StatefulWidget {
  const PersonParent({super.key});

  @override
  State<PersonParent> createState() => _PersonParentState();
}

class _PersonParentState extends State<PersonParent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parent = BlocProvider.of<AuthBlocParent>(context).modelParent;
    final displaySmall = Theme.of(context).textTheme.displaySmall;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  // Profile Header
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            parent?.name ?? "N/A",
                            style: displaySmall?.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            parent?.email ?? "N/A",
                            style: displaySmall?.copyWith(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Linked Student Section
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Linked Student",
                            style: displaySmall?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<ModelUser?>(
                            future: StudentController()
                                .getStudentById(parent?.numberId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error loading student data",
                                  style: TextStyle(color: Colors.red[300]),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return Text(
                                  "No student linked",
                                  style: TextStyle(color: Colors.grey[600]),
                                );
                              }

                              final student = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Name",
                                          style: displaySmall?.copyWith(
                                              fontSize: 18)),
                                      Text(
                                        student.name,
                                        style: displaySmall?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Email",
                                          style: displaySmall?.copyWith(
                                              fontSize: 18)),
                                      Text(
                                        student.email,
                                        style: displaySmall?.copyWith(
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Student ID",
                                          style: displaySmall?.copyWith(
                                              fontSize: 18)),
                                      Text(
                                        student.numberId,
                                        style: displaySmall?.copyWith(
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 250),

                  // Logout Button
                  Center(
                    child: InkWell(
                      onTap: logoutPerson,
                      splashColor: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.logout, color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void logoutPerson() {
    FunctionFirebaseParent.logoutParent();
    Navigator.of(context).pushReplacementNamed(LoginParent.routeName);
  }
}
