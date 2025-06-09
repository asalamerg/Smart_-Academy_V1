// lib/teacher/feature_teacher/controller_teacher.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';

class TeacherController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch teacher data by ID
  Future<ModelTeacher> getTeacherById(String teacherId) async {
    try {
      final docSnapshot =
          await _firestore.collection('teacher').doc(teacherId).get();

      if (docSnapshot.exists) {
        return ModelTeacher.fromJson(
            docSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Teacher not found');
      }
    } catch (e) {
      print("Error fetching teacher: $e");
      rethrow;
    }
  }

  // Update teacher details in Firestore
  Future<void> updateTeacher(ModelTeacher teacher) async {
    try {
      // Update the teacher's data in Firestore
      await _firestore
          .collection('teacher')
          .doc(teacher.id)
          .update(teacher.toJson());
      print("Teacher updated successfully");
    } catch (e) {
      print("Error updating teacher: $e");
    }
  }

  // Create a new teacher in Firestore
  Future<void> addTeacher(ModelTeacher teacher) async {
    try {
      // Add a new teacher document in Firestore
      await _firestore.collection('teacher').add(teacher.toJson());
      print("Teacher added successfully");
    } catch (e) {
      print("Error adding teacher: $e");
    }
  }
}
