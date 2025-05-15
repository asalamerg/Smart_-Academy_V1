import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_academy/cousrses/ControllerCourse.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
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

  @override
  void initState() {
    super.initState();
    courseDetails = _fetchCourseDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set white background here
      appBar: AppBar(
        title: const Text("Course Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue, // Keep app bar color
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
          final canEnroll =
              courseData['canEnroll'] ?? false; // Check canEnroll status

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 40,
                        color: Colors.blue[700],
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
                                  color: Colors.blue),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Course Code: $courseCode',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Course Information
                const Text('Course Information',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Divider(color: Colors.black12),
                const SizedBox(height: 12),

                _buildDetailCard(
                    title: 'Description',
                    content: courseDescription,
                    icon: Icons.description),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard(
                          title: 'Start Time',
                          content: startTime,
                          icon: Icons.access_time),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailCard(
                          title: 'End Time',
                          content: endTime,
                          icon: Icons.access_time),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildDetailCard(
                  title: 'Days',
                  content: courseDays.isEmpty
                      ? 'No days specified'
                      : courseDays.join(", "),
                  icon: Icons.calendar_today,
                ),

                const SizedBox(height: 24),

                // Toggle canEnroll
                ElevatedButton.icon(
                  onPressed: () => _toggleCanEnroll(canEnroll),
                  icon: Icon(canEnroll ? Icons.block : Icons.check_circle,
                      color: Colors.white),
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
                const SizedBox(height: 16),

                // PDF Upload Section
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
                const SizedBox(height: 16),

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

                const SizedBox(height: 24),

                // Enrolled Students
                const Text('Enrolled Students',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Divider(color: Colors.black12),
                const SizedBox(height: 12),

                if (students.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No students enrolled yet',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  Column(
                    children: [
                      for (var student in students)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(student),
                            tileColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Navigate to Edit Course screen directly
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditCourseScreen(courseId: widget.courseId),
                            ),
                          );

                          // If the screen was popped with true, refresh the data
                          if (updated == true) {
                            setState(() {
                              courseDetails = _fetchCourseDetails();
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Course'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Blue background for Edit button
                          foregroundColor:
                              Colors.white, // White text color for Edit button
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
                          // Show confirmation dialog before deleting the course
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
                            // Delete the course from Firestore
                            await FirebaseFirestore.instance
                                .collection('courses')
                                .doc(widget.courseId)
                                .delete();

                            // Show a success message and navigate back
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Course deleted successfully')),
                            );
                            Navigator.pop(
                                context); // Navigate back after deletion
                          }
                        },
                        icon: const Icon(Icons.delete,
                            color: Colors.white), // White icon for delete
                        label: const Text('Delete Course'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Colors.red, // Red background for Delete button
                          foregroundColor: Colors
                              .white, // White text color for Delete button
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
