import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late bool canEnroll;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    _getCourseStatus();
  }

  Future<void> _getCourseStatus() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .get();

    if (snapshot.exists) {
      final courseData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        canEnroll = courseData['canEnroll'] ?? true;
        isActive = courseData['isActive'] ?? true;
      });
    }
  }

  Future<void> _removeCourseFromStudents() async {
    try {
      // Get all students who are enrolled in this course
      final snapshot = await FirebaseFirestore.instance
          .collection(
              'user') // Assuming 'user' is the collection where students are stored
          .where('courses', arrayContains: widget.courseId)
          .get();

      for (var studentDoc in snapshot.docs) {
        // Remove the course from each student's 'courses' field
        await FirebaseFirestore.instance
            .collection('user') // Referencing the 'user' collection
            .doc(studentDoc.id)
            .update({
          'courses': FieldValue.arrayRemove([
            widget.courseId
          ]), // Remove the course id from the student's list
        });
        print("Course removed from student: ${studentDoc.id}");
      }
    } catch (e) {
      print("Error removing course from students: $e");
    }
  }

  Future<void> _deleteCourse(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog first
                try {
                  // Step 1: Delete the course from the `courses` collection
                  await FirebaseFirestore.instance
                      .collection('courses')
                      .doc(widget.courseId)
                      .delete();
                  print("Course deleted successfully");

                  // Step 2: Remove the course from students' course list
                  await _removeCourseFromStudents();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Course deleted successfully'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );

                  // Step 3: Navigate back to the previous screen (only if widget is mounted)
                  if (mounted) {
                    Navigator.pop(context); // Go back to the previous screen
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting course: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Future<void> _toggleActiveStatus(BuildContext context, bool isActive) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .update({
        'isActive': !isActive,
      });
      setState(() {
        this.isActive = !isActive;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course ${isActive ? 'deactivated' : 'activated'}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating course status: $e')),
      );
    }
  }

  Future<void> _toggleEnrollStatus(BuildContext context, bool canEnroll) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .update({
        'canEnroll': !canEnroll,
      });
      setState(() {
        this.canEnroll = !canEnroll;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enrollment ${canEnroll ? 'disabled' : 'enabled'}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating enrollment status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .doc(widget.courseId)
            .get(),
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
          final courseName = courseData['name'] ?? 'No Name';
          final courseCode = courseData['courseCode'] ?? 'No Code';
          final courseDescription =
              courseData['description'] ?? 'No description provided';
          final courseStartTime = courseData['startTime'] ?? 'Not specified';
          final courseEndTime = courseData['endTime'] ?? 'Not specified';
          final maxStudents = courseData['maxStudents'] ?? 0;
          final students = courseData['students'] ?? [];
          final files = courseData['files'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Course Header Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.school,
                                  size: 30, color: Colors.blue.shade700),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courseName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  Text(
                                    courseCode,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(Icons.description, 'Description',
                            courseDescription),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(Icons.access_time,
                                  'Start Time', courseStartTime),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoItem(
                                  Icons.access_time, 'End Time', courseEndTime),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(Icons.people,
                                  'Max Students', maxStudents.toString()),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoItem(Icons.person, 'Enrolled',
                                  students.length.toString()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Course Management Section
                _buildSectionTitle('Course Management'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStatusButton(
                      context,
                      icon: canEnroll ? Icons.person_remove : Icons.person_add,
                      label: canEnroll
                          ? 'Disable Enrollment'
                          : 'Enable Enrollment',
                      color: canEnroll ? Colors.orange : Colors.green,
                      onPressed: () => _toggleEnrollStatus(context, canEnroll),
                    ),
                    _buildStatusButton(
                      context,
                      icon: isActive ? Icons.pause : Icons.play_arrow,
                      label: isActive ? 'Deactivate' : 'Activate',
                      color: isActive ? Colors.blueGrey : Colors.blue,
                      onPressed: () => _toggleActiveStatus(context, isActive),
                    ),
                    _buildStatusButton(
                      context,
                      icon: Icons.delete,
                      label: 'Delete Course',
                      color: Colors.red,
                      onPressed: () => _deleteCourse(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
