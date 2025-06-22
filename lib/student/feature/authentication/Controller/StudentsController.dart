import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/student/feature/authentication/model/model_user.dart';

class StudentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all students from Firestore
  Future<List<ModelUser>> getAllStudents() async {
    try {
      // Get all students from the 'students' collection
      final snapshot = await _firestore.collection('user').get();

      // Convert the Firestore snapshot to a list of ModelUser objects
      List<ModelUser> students = snapshot.docs.map((doc) {
        return ModelUser.fromJson(doc.data());
      }).toList();

      return students;
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }

  Future<ModelUser?> getStudentById(String? numberId) async {
    if (numberId == null) return null;

    try {
      final student = await _firestore
          .collection('user')
          // Use whereIn to fetch courses
          .where('numberId', isEqualTo: numberId) // get the id of the student
          .get();

      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(student.docs.first.id)
          .get();
      if (doc.exists) {
        return ModelUser.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching student: $e");
      return null;
    }
  }
}
