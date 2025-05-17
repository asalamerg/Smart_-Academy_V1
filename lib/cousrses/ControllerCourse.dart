import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'dart:io';

class CourseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a new course to Firestore
  Future<void> addCourse({
    required ModelTeacher teacher,
    required String name,
    required String description,
    required String pdfUrl,
    required String courseCode,
    required int maxStudents,
    required String startTime,
    required String endTime,
    required List<String> days,
    required List<String> files,
    required List<String> students,
    required bool canEnroll, // Add canEnroll as a parameter
  }) async {
    try {
      await _firestore.collection('courses').add({
        'name': name,
        'description': description,
        'pdfUrl': pdfUrl,
        'courseCode': courseCode,
        'maxStudents': maxStudents,
        'startTime': startTime,
        'endTime': endTime,
        'days': days,
        'files': files,
        'students': students,
        'teacherId': teacher.id,
        'createdAt': FieldValue.serverTimestamp(),
        'canEnroll': canEnroll, // Save canEnroll status
      });
      print("Course added successfully");
    } catch (e) {
      print("Error adding course: $e");
    }
  }

  // Function to update an existing course in Firestore
  Future<void> updateCourse({
    required String courseId,
    required String name,
    required String description,
    required String pdfUrl,
    required String courseCode,
    required int maxStudents,
    required String startTime,
    required String endTime,
    required List<String> days,
    required List<String> files,
    required List<String> students,
    required bool canEnroll, // New field for enrollment status
  }) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'name': name,
        'description': description,
        'pdfUrl': pdfUrl,
        'courseCode': courseCode,
        'maxStudents': maxStudents,
        'startTime': startTime,
        'endTime': endTime,
        'days': days,
        'files': files,
        'students': students,
        'canEnroll': canEnroll, // Updating canEnroll in the Firestore document
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print("Course updated successfully");
    } catch (e) {
      print("Error updating course: $e");
    }
  }

  // Function to delete a course from Firestore
  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();
      print("Course deleted successfully");
    } catch (e) {
      print("Error deleting course: $e");
    }
  }

  // Function to enroll a student in a course
  Future<void> enrollStudentInCourse(String courseId, String studentId) async {
    try {
      // Check if the course allows enrollment
      DocumentSnapshot courseDoc =
          await _firestore.collection('courses').doc(courseId).get();
      if (courseDoc.exists) {
        bool canEnroll = courseDoc['canEnroll'] ?? false;
        if (!canEnroll) {
          print("Enrollment is closed for this course.");
          return;
        }
      }

      await _firestore.collection('courses').doc(courseId).update({
        'students': FieldValue.arrayUnion([studentId]),
      });
      print("Student enrolled successfully");
    } catch (e) {
      print("Error enrolling student: $e");
    }
  }

  // Function to remove a student from a course
  Future<void> removeStudentFromCourse(
      String courseId, String studentId) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'students': FieldValue.arrayRemove([studentId]),
      });
      print("Student removed from course successfully");
    } catch (e) {
      print("Error removing student: $e");
    }
  }

  // Function to get all courses for a student
  Future<List<Map<String, dynamic>>> getAllCourses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('courses').get();
      List<Map<String, dynamic>> courses = [];
      for (var doc in snapshot.docs) {
        courses.add(doc.data() as Map<String, dynamic>);
      }
      return courses;
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }
}

Future<String> uploadPDF(File file) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child('course_pdfs/$fileName.pdf');
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    throw Exception('Error uploading PDF: $e');
  }
}
