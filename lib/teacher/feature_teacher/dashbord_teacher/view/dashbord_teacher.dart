import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Add_CourseScreen.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/DetailScreen.dart';

class DashbordTeacher extends StatefulWidget {
  final ModelTeacher teacher;

  const DashbordTeacher({super.key, required this.teacher});

  @override
  _DashbordTeacherState createState() => _DashbordTeacherState();
}

class _DashbordTeacherState extends State<DashbordTeacher> {
  // Function to navigate to the course detail page
  void _navigateToCourseDetail(BuildContext context, String courseId) {
    // Use 'mounted' to check if the widget is still active before navigating
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CourseDetailScreen(courseId: courseId, teacher: widget.teacher),
      ),
    );
  }

  // Function to delete the course
  void _deleteCourse(BuildContext context, String courseId) async {
    try {
      // Delete the course from Firestore
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .delete();

      if (!mounted) return; // Check if the widget is still mounted

      // Show a snackbar confirming the course deletion
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Course Deleted')));
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting course')));
    }
  }

  // Navigate to Add Course Page
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('teacherId', isEqualTo: widget.teacher.id)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading courses: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final courses = snapshot.data!.docs;

          if (courses.isEmpty) {
            return Center(child: Text('No courses yet'));
          }

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              List<String> courseDays = List<String>.from(course['days'] ?? []);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(12.0),
                  title: Text(course['name'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'From ${course['startTime']} to ${course['endTime']}\nDays: ${courseDays.join(", ")}'),
                  onTap: () {
                    _navigateToCourseDetail(
                        context, course.id); // Navigate to course details
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _navigateToAddCoursePage(context), // Navigate to Add Course Page
        icon: Icon(Icons.add),
        label: Text("Add Course"),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
