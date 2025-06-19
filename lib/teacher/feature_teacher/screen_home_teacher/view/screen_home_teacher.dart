import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/chat/main_chat_screen.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/dashbord_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/person_teacher/view/person_teacher.dart';

class HomeScreenTeacher extends StatefulWidget {
  final ModelTeacher? modelTeacher;
  static const String routeName = "HomeScreenTeacher";

  const HomeScreenTeacher({
    Key? key,
    this.modelTeacher,
  }) : super(key: key);

  @override
  State<HomeScreenTeacher> createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends State<HomeScreenTeacher> {
  int select = 0;
  late Future<ModelTeacher> teacherFuture;

  @override
  void initState() {
    super.initState();
    // teacherFuture = _getTeacherData();
    teacherFuture = widget.modelTeacher != null
        ? Future.value(widget.modelTeacher!)
        : _getTeacherData();
  }

  Future<ModelTeacher> _getTeacherData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('teacher')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          return ModelTeacher(
            id: user.uid,
            name: user.displayName ?? "No Name",
            email: user.email ?? "No Email",
            numberId: data['numberId'] ?? "No ID",
          );
        } else {
          return ModelTeacher(
            id: user.uid,
            name: user.displayName ?? "No Name",
            email: user.email ?? "No Email",
            numberId: "No ID",
          );
        }
      }
      throw Exception('User not found');
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ModelTeacher>(
      future: teacherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 20),
                const Text('Loading your profile...'),
              ],
            )),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading profile',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        teacherFuture = _getTeacherData();
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          ModelTeacher teacher = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(widget.modelTeacher != null
                  ? 'Welcome, ${widget.modelTeacher!.name}'
                  : 'Welcome, Teacher'),
              centerTitle: true,
              backgroundColor: Colors.blue[700],
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE3F2FD), Colors.white]),
              ),
              child: SafeArea(
                child: select == 0
                    ? DashbordTeacher(teacher: teacher)
                    : select == 1
                        ? MainChatScreen()
                        : PersonTeacher(
                            modelTeachers: widget.modelTeacher,
                          ),
              ),
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                currentIndex: select,
                onTap: (index) {
                  setState(() {
                    select = index;
                  });
                },
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blue[700],
                unselectedItemColor: Colors.grey[600],
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                type: BottomNavigationBarType.fixed,
                elevation: 10,
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: select == 0
                          ? BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      child: const Icon(Icons.dashboard),
                    ),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: select == 1
                          ? BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      child: const Icon(Icons.chat),
                    ),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: select == 2
                          ? BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            )
                          : null,
                      child: const Icon(Icons.person),
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber, color: Colors.amber, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'No data found',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      teacherFuture = _getTeacherData();
                    });
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
