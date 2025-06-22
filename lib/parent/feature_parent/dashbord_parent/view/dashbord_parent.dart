import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/bloc_auth_parent.dart';
import 'package:smart_academy/student/feature/dashbord/view/MyCourses/CourseDetail.dart';
import 'package:smart_academy/student/feature/dashbord/view/courses/Course_Screen.dart';
import 'package:smart_academy/cousrses/ControllerCourse.dart';

class DashbordParent extends StatefulWidget {
  static const String routeName = "DashbordParent";

  const DashbordParent({super.key});

  @override
  State<DashbordParent> createState() => _DashbordParentState();
}

class _DashbordParentState extends State<DashbordParent> {
  @override
  Widget build(BuildContext context) {
    final parent = BlocProvider.of<AuthBlocParent>(context).modelParent;

    if (parent == null || parent.numberId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 20),
              Text(
                'No Student Linked',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              const Text('No student is linked to this parent account'),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // يمكنك إضافة تنقل إلى صفحة إعدادات لربط طالب
                },
                child: const Text('Link a Student'),
              ),
            ],
          ),
        ),
      );
    }

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
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: CourseController().getCoursesForStudentToPar(
              parent.numberId!), // استدعاء الدالة هنا
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No courses found.'));
            }

            final courses = snapshot.data!;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                await Future.delayed(const Duration(seconds: 1));
              },
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final courseData = courses[index];
                  final courseId = courseData['id'];
                  final courseName = courseData['name'] ?? 'Unnamed Course';
                  final courseCode = courseData['courseCode'] ?? 'No Code';

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailWithGradesScreen(
                            courseId: courseId,
                            studentId: parent.numberId!,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.withOpacity(0.8),
                              Colors.blue.withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.school, size: 30, color: Colors.white),
                              const Spacer(),
                              Text(
                                courseName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                courseCode,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
