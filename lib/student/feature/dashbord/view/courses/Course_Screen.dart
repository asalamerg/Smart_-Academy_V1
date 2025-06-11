import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/student/feature/dashbord/view/courses/CourseDetail.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Courses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 4,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: StreamBuilder<QuerySnapshot>(
          // Modify the stream to filter courses with canEnroll == true
          stream: FirebaseFirestore.instance
              .collection('courses')
              .where('canEnroll', isEqualTo: true) // Filter by canEnroll field
              .where('isdelet',
                  isEqualTo: false) // Ensure courses are not deleted
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No courses available.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            final courses = snapshot.data!.docs;

            return ListView.separated(
              itemCount: courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final course = courses[index];
                final courseName = course['name'] ?? 'Unnamed Course';
                final courseDescription =
                    course['description'] ?? 'No description provided';
                final courseId = course.id;
                final teacherId = course['teacherId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('teacher')
                      .doc(teacherId)
                      .get(),
                  builder: (context, teacherSnapshot) {
                    if (teacherSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      );
                    }

                    if (teacherSnapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${teacherSnapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (!teacherSnapshot.hasData ||
                        !teacherSnapshot.data!.exists) {
                      return const Center(
                        child: Text(
                          'Teacher not found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    final teacherData =
                        teacherSnapshot.data!.data() as Map<String, dynamic>;
                    final teacherName =
                        teacherData['name'] ?? 'Unknown Teacher';

                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseDetailScreen(courseId: courseId),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courseName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                  'Course Code:', course['courseCode']),
                              _buildInfoRow('Start Time:', course['startTime']),
                              _buildInfoRow('End Time:', course['endTime']),
                              _buildInfoRow('Teacher:', teacherName),
                              const SizedBox(height: 8),
                              Text(
                                courseDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
