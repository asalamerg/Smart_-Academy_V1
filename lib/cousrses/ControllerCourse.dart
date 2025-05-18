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
    bool isActive = true,
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
        'canEnroll': canEnroll,
        'isActive': isActive,
      });
      print("Course added successfully");
    } catch (e) {
      print("Error adding course: $e");
    }
  }

  Future<void> toggleCourseActiveStatus(String courseId, bool isActive) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'isActive': isActive,
      });
      print("Course active status updated successfully");
    } catch (e) {
      print("Error updating course active status: $e");
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
    required bool canEnroll,
    required bool isActive, // NEW: Added isActive parameter
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
        'canEnroll': canEnroll,
        'isActive': isActive, // NEW: Update isActive in the Firestore document
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

  Future<List<Map<String, dynamic>>> getCoursesForTeacher(
      String teacherId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('teacherId', isEqualTo: teacherId)
          .where('isActive', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> courses = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // تأكد من إضافة id
        courses.add(data);
      }
      return courses;
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
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

  setStudentData(
      {required String courseId,
      required String studentId,
      required Map<String, String> attendance}) {}
}

Future<List<Map<String, dynamic>>> getAllActiveCourses() async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection('courses')
        .where('isActive', isEqualTo: true) // NEW: Filter by active status
        .get();

    List<Map<String, dynamic>> courses = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Include document ID
      courses.add(data);
    }
    return courses;
  } catch (e) {
    print("Error fetching active courses: $e");
    return [];
  }
}

Future<void> removeStudentFromCourse(String courseId, String studentId) async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('courses').doc(courseId).update({
      'students': FieldValue.arrayRemove([studentId]),
    });
    print("Student removed from course successfully");
  } catch (e) {
    print("Error removing student: $e");
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

Future<void> setStudentData({
  required String courseId,
  required String studentId,
  Map<String, dynamic>? grades,
  Map<String, dynamic>? attendance,
}) async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection('courses')
        .doc(courseId)
        .collection('studentData')
        .doc(studentId);

    Map<String, dynamic> dataToUpdate = {};
    if (grades != null) dataToUpdate['grades'] = grades;
    if (attendance != null) dataToUpdate['attendance'] = attendance;

    await docRef.set(dataToUpdate, SetOptions(merge: true));
    print("Student data updated successfully");
  } catch (e) {
    print("Error updating student data: $e");
    throw e;
  }
}
