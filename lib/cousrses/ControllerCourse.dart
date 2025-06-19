import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

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
    // required List<String> students,
    bool isActive = true,
    bool isdelet = false,
    required bool canEnroll,
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
        // 'students': students,
        'teacherId': teacher.id,
        'createdAt': FieldValue.serverTimestamp(),
        'canEnroll': canEnroll,
        'isActive': isActive,
        'isdelet': isdelet,
      });
      print("Course added successfully");
    } catch (e) {
      print("Error adding course: $e");
    }
  }

  // Function to save grades to student data
  Future<void> saveGradesToStudentData({
    required String courseId,
    required String examName,
    required int maxGrade,
    required Map<String, dynamic> grades, // map studentId -> grade (int)
  }) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // لكل طالب في grades، حدّث وثيقة الطالب
      for (var entry in grades.entries) {
        final studentId = entry.key;
        final grade = entry.value;

        final docRef = firestore
            .collection('courses')
            .doc(courseId)
            .collection('studentData')
            .doc(studentId);

        // إضافة أو تحديث الدرجات الخاصة بالامتحان
        await docRef.set({
          'grades': {
            examName: {
              'grade': grade,
              'maxGrade': maxGrade,
            }
          }
        }, SetOptions(merge: true)); // استخدام merge لتحديث البيانات دون مسحها

        print("Grade saved for student: $studentId");
      }

      print('Grades saved to studentData successfully');
    } catch (e) {
      print('Error saving grades to studentData: $e');
      throw e;
    }
  }

  // Function to save grade for a student (alternative for adding grades to exams)
  Future<void> saveGradeForStudent({
    required String courseId,
    required String studentId,
    required String examName,
    required int maxGrade,
    required int grade,
  }) async {
    try {
      await _firestore
          .collection('courses') // collection الخاصة بالمواد
          .doc(courseId) // id للمادة
          .collection('studentData') // collection الخاصة ببيانات الطلاب
          .doc(studentId) // id الطالب
          .collection('grades') // collection الخاصة بالعلامات
          .add({
        'examName': examName,
        'maxGrade': maxGrade,
        'grade': grade,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Grade saved for student: $studentId");
    } catch (e) {
      throw Exception("Failed to save grade: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getCoursesForStudent(
      String studentId) async {
    try {
      // أولاً، احصل على المستند الخاص بالطالب من الـ Firestore
      final studentDoc =
          await _firestore.collection('user').doc(studentId).get();

      if (!studentDoc.exists) {
        print("Student not found.");
        return [];
      }

      // الآن احصل على الكورسات المسجلة للطالب من الـ field 'courses' في المستند
      final courses = List<String>.from(studentDoc.data()?['courses'] ?? []);

      if (courses.isEmpty) {
        print("No courses found for this student.");
        return [];
      }

      // الآن احصل على الكورسات بناءً على الـ courseId
      final courseSnapshot = await _firestore
          .collection('courses')
          .where(FieldPath.documentId,
              whereIn: courses) // Use whereIn to fetch courses
          .where('isActive', isEqualTo: true) // Ensure the course is active
          .where('isdelet',
              isEqualTo: false) // Ensure the course is not deleted
          .get();

      List<Map<String, dynamic>> courseData = [];
      for (var doc in courseSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add course ID for further reference
        courseData.add(data);
      }

      return courseData;
    } catch (e) {
      print("Error fetching courses for student: $e");
      return [];
    }
  }

  // Function to toggle course active status
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
    required bool isActive,
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
        'isActive': isActive,
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
      // Step 1: Get all students enrolled in the course and remove the courseId
      final snapshot = await _firestore
          .collection('user')
          .where('courses',
              arrayContains: courseId) // Find students enrolled in this course
          .get();

      for (var studentDoc in snapshot.docs) {
        // Remove the courseId from each student's courses list
        await _firestore.collection('user').doc(studentDoc.id).update({
          'courses': FieldValue.arrayRemove([courseId]),
        });
        print("Course removed from student: ${studentDoc.id}");
      }

      // Step 2: Set 'isdelet' to true instead of deleting the course
      await _firestore.collection('courses').doc(courseId).update({
        'isdelet': true,
      });

      print("Course marked as deleted (isdelet = true)");
    } catch (e) {
      print("Error deleting course: $e");
    }
  }

  // Function to enroll a student in a course
  // Future<void> enrollStudentInCourse(String courseId, String studentId) async {
  //   try {
  //     DocumentSnapshot courseDoc =
  //         await _firestore.collection('courses').doc(courseId).get();
  //     if (courseDoc.exists) {
  //       bool canEnroll = courseDoc['canEnroll'] ?? false;
  //       if (!canEnroll) {
  //         print("Enrollment is closed for this course.");
  //         return;
  //       }
  //     }

  //     await _firestore.collection('courses').doc(courseId).update({
  //       'students': FieldValue.arrayUnion([studentId]),
  //     });
  //     print("Student enrolled successfully");
  //   } catch (e) {
  //     print("Error enrolling student: $e");
  //   }
  // }

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

  // Function to get courses for a teacher
  Future<List<Map<String, dynamic>>> getCoursesForTeacher(
      String teacherId) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .where('teacherId', isEqualTo: teacherId)
          .where('isActive', isEqualTo: true)
          .where('isdelet', isEqualTo: false)
          .get();

      List<Map<String, dynamic>> courses = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        courses.add(data);
      }
      return courses;
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }

  // Function to get all courses
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

  // Function to upload a PDF to Firebase Storage
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
}
