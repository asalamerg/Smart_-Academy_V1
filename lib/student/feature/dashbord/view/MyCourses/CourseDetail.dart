import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailWithGradesScreen extends StatelessWidget {
  final String courseId;
  final String studentId;

  const CourseDetailWithGradesScreen({
    super.key,
    required this.courseId,
    required this.studentId,
  });

  // جلب بيانات الكورس
  Future<Map<String, dynamic>> _fetchCourseDetails() async {
    try {
      final courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();

      if (courseDoc.exists) {
        return courseDoc.data() ?? {};
      } else {
        throw 'Course not found';
      }
    } catch (e) {
      print('Error fetching course details: $e');
      return {};
    }
  }

  // جلب درجات الطالب
  Future<Map<String, dynamic>> _fetchGrades() async {
    try {
      final studentDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('studentData')
          .doc(studentId)
          .get();

      if (studentDoc.exists) {
        final grades = studentDoc.data()?['grades'];
        return grades ?? {};
      } else {
        throw 'Student data not found';
      }
    } catch (e) {
      print('Error fetching grades: $e');
      return {};
    }
  }

  // جلب بيانات الحضور
  Future<Map<String, dynamic>> _fetchAttendance() async {
    try {
      final studentDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('studentData')
          .doc(studentId)
          .get();

      if (studentDoc.exists) {
        final attendance = studentDoc.data()?['attendance'];
        return attendance ?? {};
      } else {
        throw 'Student data not found';
      }
    } catch (e) {
      print('Error fetching attendance: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Course Details & Grades',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Tajawal')),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Future.wait(
            [_fetchCourseDetails(), _fetchGrades(), _fetchAttendance()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: Colors.red.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                        fontSize: 16, color: Colors.red, fontFamily: 'Tajawal'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Go Back',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Tajawal')),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(
                icon: Icons.info_outline, message: 'No course data available');
          }

          final courseData = snapshot.data![0];
          final grades = snapshot.data![1];
          final attendance = snapshot.data![2];

          final courseName = courseData['name'] ?? 'Unnamed Course';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Name
                _buildCourseInfoCard(
                  title: 'Course Name',
                  value: courseName,
                  icon: Icons.school,
                ),

                // Course Description
                _buildCourseInfoCard(
                  title: 'Description',
                  value: courseDescription,
                  icon: Icons.description,
                ),

                // Course Code
                _buildCourseInfoCard(
                  title: 'Course Code',
                  value: courseCode,
                  icon: Icons.code,
                ),

                // Start and End Time
                Row(
                  children: [
                    Expanded(
                      child: _buildCourseInfoCard(
                        title: 'Start Time',
                        value: courseStartTime,
                        icon: Icons.access_time,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCourseInfoCard(
                        title: 'End Time',
                        value: courseEndTime,
                        icon: Icons.access_time,
                      ),
                    ),
                  ],
                ),

                // Max Students and Enrolled
                Row(
                  children: [
                    Expanded(
                      child: _buildCourseInfoCard(
                        title: 'Max Students',
                        value: maxStudents.toString(),
                        icon: Icons.people,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Expanded(
                    //   child: _buildCourseInfoCard(
                    //     title: 'Enrolled Students',
                    //     value: students.length.toString(),
                    //     icon: Icons.person_add,
                    //   ),
                    // ),
                  ],
                ),

                // Course Materials
                const SizedBox(height: 24),
                _buildSectionTitle('Course Materials'),
                const SizedBox(height: 12),
                if (files.isEmpty)
                  _buildEmptyState(
                      icon: Icons.attach_file,
                      message: 'No materials available',
                      small: true)
                else
                  // Column(
                  //   children: files.map<Widget>((file) {
                  //     return _buildFileItem(context, file['name'], file['url']);
                  //   }).toList(),
                  // ),

                  // Grades Section
                  const SizedBox(height: 24),
                _buildSectionTitle('Grades Summary'),
                const SizedBox(height: 12),
                if (grades.isEmpty)
                  _buildEmptyState(
                      icon: Icons.grade,
                      message: 'No grades available',
                      small: true)
                else
                  _buildGradesSection(grades),

                // Attendance Section
                const SizedBox(height: 24),
                _buildSectionTitle('Attendance Records'),
                const SizedBox(height: 12),
                if (attendance.isEmpty)
                  _buildEmptyState(
                      icon: Icons.calendar_today,
                      message: 'No attendance records',
                      small: true)
                else
                  _buildAttendanceSection(attendance),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
        fontFamily: 'Tajawal',
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, String fileName, String fileUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.insert_drive_file, color: Colors.blue.shade700),
        ),
        title: Text(
          fileName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Tajawal',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(Icons.download, color: Colors.blue.shade700),
          onPressed: () async {
            if (await canLaunch(fileUrl)) {
              await launch(fileUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not open file'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildGradesSection(Map<String, dynamic> grades) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ...grades.entries.map((entry) {
            final examName = entry.key;
            final gradeData = entry.value;
            final grade = (gradeData['grade'] ?? 0).toDouble();
            final maxGrade = (gradeData['maxGrade'] ?? 0).toDouble();
            final percentage = (maxGrade > 0) ? (grade / maxGrade) * 100 : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          examName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      Text(
                        '${grade.toStringAsFixed(1)}/${maxGrade.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(percentage),
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        _getGradeStatus(percentage),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getProgressColor(percentage),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.5),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAttendanceSection(Map<String, dynamic> attendance) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ...attendance.entries.map((entry) {
            final date = entry.key;
            final status = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _formatDate(date),
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: status == 'Absent'
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: status == 'Absent'
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == 'Absent' ? Icons.close : Icons.check,
                              size: 16,
                              color: status == 'Absent'
                                  ? Colors.red.shade600
                                  : Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status == 'Absent' ? 'Absent' : 'Present',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: status == 'Absent'
                                    ? Colors.red.shade600
                                    : Colors.green.shade600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.5),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
      {required IconData icon, required String message, bool small = false}) {
    return Container(
      padding: EdgeInsets.all(small ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: small ? 36 : 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: small ? 14 : 16,
              color: Colors.grey.shade600,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 85) return Colors.green.shade600;
    if (percentage >= 70) return Colors.lightGreen.shade500;
    if (percentage >= 50) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  String _getGradeStatus(double percentage) {
    if (percentage >= 85) return 'Excellent';
    if (percentage >= 70) return 'Good';
    if (percentage >= 50) return 'Average';
    return 'Needs Improvement';
  }

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final formatter = DateFormat('EEEE, d MMMM yyyy', 'ar');
      return formatter.format(date);
    } catch (e) {
      return timestamp.length >= 10 ? timestamp.substring(0, 10) : timestamp;
    }
  }
}
