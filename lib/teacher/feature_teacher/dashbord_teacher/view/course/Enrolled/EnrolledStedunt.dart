import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Enrolled/for_student/attendance/Attendance_Screen.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Enrolled/for_student/grades/Grades_Screen.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Enrolled/for_student/student/StudentDetail_Screen.dart';

class EnrolledStudentsScreen extends StatelessWidget {
  final String courseId;

  const EnrolledStudentsScreen({
    super.key,
    required this.courseId,
  });

  // دالة مساعدة لجلب بيانات الطالب من مجموعة users
  Future<Map<String, dynamic>> _fetchStudentDetails(String studentId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(studentId)
        .get();

    if (userDoc.exists) {
      return {
        'id': studentId,
        'name': userDoc.data()!['name'] ?? 'No Name',
        'numberId': userDoc.data()!['numberId'] ?? 'No ID',
      };
    }
    return {
      'id': studentId,
      'name': 'Unknown Student',
      'numberId': 'No ID',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Enrolled Students'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .collection('studentData')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching students.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No students enrolled yet.'));
          }

          final studentIds = snapshot.data!.docs.map((doc) => doc.id).toList();

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: Future.wait(studentIds.map(_fetchStudentDetails)),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (futureSnapshot.hasError) {
                return const Center(
                    child: Text('Error fetching student details.'));
              }

              final students = futureSnapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(student['name']),
                    subtitle: Text(student['numberId']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetailScreen(
                            student: student,
                            courseId: courseId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              heroTag: 'attendance',
              icon: const Icon(Icons.event_available),
              label: const Text('الحضور والغياب'),
              backgroundColor: Colors.blue,
              onPressed: () async {
                // جلب بيانات الطلاب مع أسمائهم من مجموعة users
                final snapshot = await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('studentData')
                    .get();

                final studentIds = snapshot.docs.map((doc) => doc.id).toList();
                final students =
                    await Future.wait(studentIds.map(_fetchStudentDetails));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceScreen(
                      students: students,
                      courseId: courseId,
                    ),
                  ),
                );
              },
            ),
            FloatingActionButton.extended(
              heroTag: 'grades',
              icon: const Icon(Icons.grade),
              label: const Text('إضافة العلامات'),
              backgroundColor: Colors.green,
              onPressed: () async {
                // جلب بيانات الطلاب مع أسمائهم من مجموعة users
                final snapshot = await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(courseId)
                    .collection('studentData')
                    .get();

                final studentIds = snapshot.docs.map((doc) => doc.id).toList();
                final students =
                    await Future.wait(studentIds.map(_fetchStudentDetails));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GradesScreen(
                      students: students,
                      courseId: courseId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
