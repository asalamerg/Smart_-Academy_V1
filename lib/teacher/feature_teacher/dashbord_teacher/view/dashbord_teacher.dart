import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Add_CourseScreen.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/DetailScreen.dart';
import 'package:smart_academy/cousrses/ControllerCourse.dart';

class DashbordTeacher extends StatefulWidget {
  final ModelTeacher teacher;

  const DashbordTeacher({super.key, required this.teacher});

  @override
  _DashbordTeacherState createState() => _DashbordTeacherState();
}

class _DashbordTeacherState extends State<DashbordTeacher> {
  final CourseController _courseController = CourseController();

  void _navigateToCourseDetail(BuildContext context, String courseId) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CourseDetailScreen(courseId: courseId, teacher: widget.teacher),
      ),
    );
  }

  void _navigateToAddCoursePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCourseScreen(teacher: widget.teacher),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _courseController.getCoursesForTeacher(widget.teacher.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading courses: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final courses = snapshot.data ?? [];

          if (courses.isEmpty) {
            return Center(
                child: Text(
                    'No courses found for teacher ID: ${widget.teacher.id}'));
          }

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              List<String> courseDays = List<String>.from(course['days'] ?? []);
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text(course['name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'From ${course['startTime'] ?? ''} to ${course['endTime'] ?? ''}\nDays: ${courseDays.join(", ")}'),
                  onTap: () {
                    _navigateToCourseDetail(context, course['id'] ?? '');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddCoursePage(context),
        icon: const Icon(Icons.add),
        label: const Text("Add Course"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
