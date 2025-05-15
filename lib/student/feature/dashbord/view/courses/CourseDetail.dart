import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: const Text("Course Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 5,
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get(), // Fetch course details from Firestore using the courseId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Course not found.'));
          }

          final courseData = snapshot.data!.data() as Map<String, dynamic>;

          final courseName = courseData['name'] ?? 'Unnamed Course';
          final courseCode = courseData['courseCode'] ?? 'No Code';
          final courseDescription =
              courseData['description'] ?? 'No description provided';
          final courseStartTime = courseData['startTime'] ?? 'Not specified';
          final courseEndTime = courseData['endTime'] ?? 'Not specified';
          final courseDays = List<String>.from(courseData['days'] ?? []);
          final teacherId = courseData['teacherId'];

          // Fetch the teacher's name based on the teacherId
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('teacher')
                .doc(teacherId)
                .get(), // Fetch the teacher's data
            builder: (context, teacherSnapshot) {
              if (teacherSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (teacherSnapshot.hasError) {
                return Center(child: Text('Error: ${teacherSnapshot.error}'));
              }

              if (!teacherSnapshot.hasData || !teacherSnapshot.data!.exists) {
                return const Center(child: Text('Teacher not found.'));
              }

              final teacherData =
                  teacherSnapshot.data!.data() as Map<String, dynamic>;
              final teacherName = teacherData['name'] ?? 'Unknown Teacher';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      courseName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                    ),
                    const SizedBox(height: 16),

                    // Course Code
                    _buildDetailCard(
                      title: 'Course Code',
                      content: courseCode,
                      icon: Icons.code,
                    ),

                    const SizedBox(height: 16),

                    // Teacher Name
                    _buildDetailCard(
                      title: 'Teacher',
                      content: teacherName,
                      icon: Icons.person,
                    ),

                    const SizedBox(height: 16),

                    // Description
                    _buildDetailCard(
                      title: 'Description',
                      content: courseDescription,
                      icon: Icons.description,
                    ),

                    const SizedBox(height: 16),

                    // Start and End Time
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailCard(
                            title: 'Start Time',
                            content: courseStartTime,
                            icon: Icons.access_time,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDetailCard(
                            title: 'End Time',
                            content: courseEndTime,
                            icon: Icons.access_time,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Days
                    _buildDetailCard(
                      title: 'Days',
                      content: courseDays.isEmpty
                          ? 'No days specified'
                          : courseDays.join(", "),
                      icon: Icons.calendar_today,
                    ),

                    const SizedBox(height: 32),

                    // Enroll Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add functionality to enroll in the course
                          _enrollStudent(context, courseId);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Enroll in Course',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper method to build detail cards
  Widget _buildDetailCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Enroll student in the course
  // Enroll student in the course and add course code to student's record
  Future<void> _enrollStudent(BuildContext context, String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final studentId = user.uid;

      // First, add student to the course's student list in Firestore
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .update({
        'students': FieldValue.arrayUnion([studentId]),
      });

      // Now, add the course code to the student's courses list in Firestore
      final courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();
      final courseData = courseSnapshot.data() as Map<String, dynamic>;
      final courseCode = courseData['courseCode'] ?? 'No Code';

      // Add courseCode to the student's courses list in Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(studentId)
          .update({
        'courses': FieldValue.arrayUnion(
            [courseCode]), // Add courseCode to the student's courses list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You have successfully enrolled in the course!')),
      );
    } else {
      // If the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to enroll in the course.')),
      );
    }
  }
}
