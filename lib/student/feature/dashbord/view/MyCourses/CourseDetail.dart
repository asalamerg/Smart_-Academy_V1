import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; // تأكد من استيراد هذا الحزمة

class CourseDetailWithGradesScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailWithGradesScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final blueColor = Colors.blue.shade700;
    final lightBlue = Colors.blue.shade50;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Course Details & Grades',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: blueColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Course not found',
                    style: TextStyle(
                      fontSize: 18,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          final courseData = snapshot.data!.data() as Map<String, dynamic>;
          final courseName = courseData['name'] ?? 'Unnamed Course';
          final courseCode = courseData['courseCode'] ?? 'No Code';
          final courseDescription =
              courseData['description'] ?? 'No description provided';
          final courseStartTime = courseData['startTime'] ?? 'Not specified';
          final courseEndTime = courseData['endTime'] ?? 'Not specified';
          final teacherId = courseData['teacherId'] ?? '';

          // جلب روابط ملفات PDF (إن وجدت)
          final List<dynamic> pdfFilesDynamic = courseData['files'] ?? [];
          final List<String> pdfFiles = pdfFilesDynamic.cast<String>();

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('teacher')
                .doc(teacherId)
                .get(),
            builder: (context, teacherSnapshot) {
              if (teacherSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              }

              if (!teacherSnapshot.hasData || !teacherSnapshot.data!.exists) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_off,
                          size: 48, color: Colors.blue),
                      const SizedBox(height: 16),
                      Text(
                        'Teacher not found',
                        style: TextStyle(
                          fontSize: 18,
                          color: blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final teacherData =
                  teacherSnapshot.data!.data() as Map<String, dynamic>;
              final teacherName = teacherData['name'] ?? 'Unknown Teacher';

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(user?.uid)
                    .collection('courses')
                    .doc(courseId)
                    .snapshots(),
                builder: (context, studentCourseSnapshot) {
                  if (studentCourseSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  }
                  if (!studentCourseSnapshot.hasData ||
                      !studentCourseSnapshot.data!.exists) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.school,
                              size: 48, color: Colors.blue),
                          const SizedBox(height: 16),
                          Text(
                            'No enrollment data',
                            style: TextStyle(
                              fontSize: 18,
                              color: blueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You are not enrolled in this course',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  final studentCourseData = studentCourseSnapshot.data!.data()
                          as Map<String, dynamic>? ??
                      {};

                  final grades = studentCourseData['grades'] ?? {};
                  final attendance = studentCourseData['attendance'] ?? {};

                  Widget buildInfoCard(
                      String title, String content, IconData icon) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.blue.shade100,
                          width: 1,
                        ),
                      ),
                      color: lightBlue,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(icon, size: 24, color: blueColor),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: blueColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    content,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  Widget buildGradeItem(String title, String value) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.shade100,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: blueColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: blueColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  Widget buildAttendanceItem(String date, String status) {
                    final isPresent = status.toLowerCase() == 'present';
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.shade100,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPresent
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isPresent ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // إضافة عرض ملفات PDF
                  Widget buildPdfList() {
                    if (pdfFiles.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No PDF files uploaded.',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Course Materials:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var url in pdfFiles)
                          ListTile(
                            leading: const Icon(Icons.picture_as_pdf,
                                color: Colors.red),
                            title: Text(
                              url.split('/').last,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Could not open PDF')),
                                );
                              }
                            },
                          ),
                      ],
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.shade100,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: 40,
                                color: blueColor,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      courseName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: blueColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Course Code: $courseCode',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: blueColor.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Course Information Section
                        Text(
                          'Course Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Colors.blue.shade100),
                        const SizedBox(height: 12),

                        buildInfoCard('Teacher', teacherName, Icons.person),
                        buildInfoCard(
                            'Schedule',
                            '$courseStartTime - $courseEndTime',
                            Icons.access_time),
                        buildInfoCard('Description', courseDescription,
                            Icons.description),
                        buildInfoCard(
                            'Days',
                            courseData['days'] != null
                                ? (courseData['days'] as List<dynamic>)
                                    .join(", ")
                                : 'No days specified',
                            Icons.calendar_today),

                        // PDF Files Section
                        const SizedBox(height: 24),
                        buildPdfList(),

                        // Grades Section
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Text(
                              'Grades',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: blueColor,
                              ),
                            ),
                            const Spacer(),
                            if (grades.isNotEmpty)
                              Chip(
                                label: Text(
                                  'Average: ${_calculateAverage(grades.values)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: blueColor,
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Colors.blue.shade100),
                        const SizedBox(height: 12),

                        if (grades.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.assignment,
                                    size: 48,
                                    color: Colors.blue.shade200,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No grades available yet',
                                    style: TextStyle(
                                      color: Colors.blue.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Column(
                            children: grades.entries
                                .map((e) => buildGradeItem(e.key, e.value))
                                .toList(),
                          ),

                        // Attendance Section
                        const SizedBox(height: 24),
                        Text(
                          'Attendance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Colors.blue.shade100),
                        const SizedBox(height: 12),

                        if (attendance.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_note,
                                    size: 48,
                                    color: Colors.blue.shade200,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No attendance records yet',
                                    style: TextStyle(
                                      color: Colors.blue.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Column(
                            children: attendance.entries
                                .map((e) => buildAttendanceItem(e.key, e.value))
                                .toList(),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _calculateAverage(Iterable<dynamic> grades) {
    try {
      final numericGrades =
          grades.map((g) => double.tryParse(g.toString()) ?? 0.0);
      final average =
          numericGrades.reduce((a, b) => a + b) / numericGrades.length;
      return average.toStringAsFixed(1);
    } catch (e) {
      return 'N/A';
    }
  }
}
