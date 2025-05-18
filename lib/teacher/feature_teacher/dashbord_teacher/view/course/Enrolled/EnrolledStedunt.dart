import 'package:flutter/material.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Enrolled/Attendance_Screen.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Enrolled/Grades_Screen.dart';

class EnrolledStudentsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> students;
  final String courseId;

  const EnrolledStudentsScreen({
    super.key,
    required this.students,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      appBar: AppBar(
        title: const Text('Enrolled Students'),
        backgroundColor: Colors.blue,
      ),
      body: students.isEmpty
          ? const Center(child: Text('No students enrolled yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(student['name'] ?? 'No Name'),
                  // يمكنك إضافة المزيد من التفاصيل مثل البريد الإلكتروني هنا
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
              onPressed: () {
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
              onPressed: () {
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
