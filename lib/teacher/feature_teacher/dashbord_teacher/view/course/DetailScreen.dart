import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_academy/cousrses/ControllerCourse.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/Enrolled/EnrolledStedunt.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/course/editCourses.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  final ModelTeacher teacher;

  const CourseDetailScreen(
      {super.key, required this.courseId, required this.teacher});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Future<DocumentSnapshot> courseDetails;
  List<String> pdfUrls = [];

  // Fetch course details from Firestore
  Future<DocumentSnapshot> _fetchCourseDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('files')) {
        setState(() {
          pdfUrls = List<String>.from(data['files']);
        });
      }
    }

    return snapshot;
  }

  // Function to pick and upload PDF file
  Future<void> _pickAndUploadPDF() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);

      if (file == null) return;

      File selectedFile = File(file.path);

      // Upload the selected file to Firebase Storage
      String pdfUrl = await uploadPDF(selectedFile);

      // Add the uploaded PDF URL to Firestore
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .update({
        'files': FieldValue.arrayUnion([pdfUrl]),
      });

      setState(() {
        pdfUrls.add(pdfUrl);
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading file: $e')));
    }
  }

  // Upload PDF to Firebase Storage
  Future<String> uploadPDF(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child("course_pdfs/$fileName.pdf");
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open PDF')));
    }
  }

  // Function to toggle the canEnroll status
  Future<void> _toggleCanEnroll(bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .update({'canEnroll': !currentStatus});

      setState(() {
        courseDetails = _fetchCourseDetails(); // Refresh course details
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Enrollment status updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating enrollment status: $e')));
    }
  }

  Future<List<Map<String, dynamic>>> fetchStudentNames(
      List<dynamic> studentIds) async {
    List<Map<String, dynamic>> studentsData = [];
    for (String id in studentIds) {
      final doc =
          await FirebaseFirestore.instance.collection('user').doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        studentsData.add({
          'id': id,
          'name': data['name'] ?? 'No Name',
          // يمكنك إضافة حقول إضافية هنا إذا أردت
        });
      }
    }
    return studentsData;
  }

  @override
  void initState() {
    super.initState();
    courseDetails = _fetchCourseDetails();
  }

  @override
  Widget build(BuildContext context) {
    final blueColor = Colors.blue.shade700;
    final lightBlue = Colors.blue.shade50;

    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء مريحة للعين
      appBar: AppBar(
        title: const Text("Course Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: courseDetails,
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
          final startTime = courseData['startTime'] ?? 'Not specified';
          final endTime = courseData['endTime'] ?? 'Not specified';
          final courseDays = List<String>.from(courseData['days'] ?? []);
          final students = List<String>.from(courseData['students'] ?? []);
          final canEnroll = courseData['canEnroll'] ?? false;
          final studentsIds = List<dynamic>.from(courseData['students'] ?? []);
          final studentNamesFuture = fetchStudentNames(studentsIds);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان الكورس مع خلفية مميزة
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: blueColor.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: blueColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.school, size: 48, color: blueColor),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(courseName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: blueColor,
                                )),
                            const SizedBox(height: 6),
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

                const SizedBox(height: 30),

                // معلومات الكورس
                Text('Course Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    )),
                const SizedBox(height: 12),
                Divider(color: blueColor.withOpacity(0.2)),
                const SizedBox(height: 12),

                _buildDetailCard('Description', courseDescription,
                    Icons.description, blueColor, lightBlue),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard('Start Time', startTime,
                          Icons.access_time, blueColor, lightBlue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailCard('End Time', endTime,
                          Icons.access_time, blueColor, lightBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildDetailCard(
                    'Days',
                    courseDays.isEmpty
                        ? 'No days specified'
                        : courseDays.join(", "),
                    Icons.calendar_today,
                    blueColor,
                    lightBlue),
                const SizedBox(height: 24),

                // زر التبديل canEnroll
                ElevatedButton.icon(
                  onPressed: () => _toggleCanEnroll(canEnroll),
                  icon: Icon(
                    canEnroll ? Icons.block : Icons.check_circle,
                    color: Colors.white,
                  ),
                  label: Text(
                      canEnroll ? 'Disable Enrollment' : 'Enable Enrollment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canEnroll ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // زر رفع ملفات PDF
                ElevatedButton.icon(
                  onPressed: _pickAndUploadPDF,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // عرض ملفات PDF المرفوعة
                if (pdfUrls.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No PDF files uploaded yet.',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Uploaded Files:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      for (var url in pdfUrls)
                        ListTile(
                          leading: const Icon(Icons.picture_as_pdf,
                              color: Colors.red),
                          title: Text(url.split('/').last,
                              overflow: TextOverflow.ellipsis),
                          onTap: () => _launchURL(url),
                        ),
                    ],
                  ),
                const SizedBox(height: 30),

                // زر عرض قائمة الطلاب المفتوحة
                ElevatedButton.icon(
                  onPressed: () async {
                    final studentsList = await studentNamesFuture;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnrolledStudentsScreen(
                          students: studentsList,
                          courseId: widget.courseId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.people),
                  label: Text('View Enrolled Students (${students.length})'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                const SizedBox(height: 30),

                // أزرار التعديل والحذف
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditCourseScreen(courseId: widget.courseId),
                            ),
                          );

                          if (updated == true) {
                            setState(() {
                              courseDetails = _fetchCourseDetails();
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Course'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Course'),
                              content: const Text(
                                  'Are you sure you want to delete this course?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true) {
                            await FirebaseFirestore.instance
                                .collection('courses')
                                .doc(widget.courseId)
                                .delete();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Course deleted successfully')),
                            );
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text('Delete Course'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
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

  Widget _buildDetailCard(String title, String content, IconData icon,
      Color titleColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: titleColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: titleColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: titleColor)),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// الشاشة الجديدة لعرض الطلاب المسجلين
