import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  String id;
  String name;
  String description;
  String pdfUrl; // URL of the PDF file in Firebase Storage
  String courseCode; // Course code (e.g., "CS101")
  int maxStudents; // Maximum number of students allowed
  String startTime; // Start time of the course (e.g., "10:00 AM")
  String endTime; // End time of the course (e.g., "12:00 PM")
  List<String> students; // List of student IDs who are enrolled in the course
  List<String>
      files; // List of file URLs (additional files related to the course)
  bool canEnroll; // Determines if students can enroll in the course
  bool isActive;

  // Constructor
  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.pdfUrl,
    required this.courseCode,
    required this.maxStudents,
    required this.startTime,
    required this.endTime,
    required this.students,
    required this.files,
    required this.isActive,
    required this.canEnroll, // Adding canEnroll
  });

  // Convert a course to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'pdfUrl': pdfUrl,
      'courseCode': courseCode,
      'maxStudents': maxStudents,
      'startTime': startTime,
      'endTime': endTime,
      'students': students, // List of enrolled students
      'files': files,
      'canEnroll': canEnroll, // Include canEnroll in the map
      'isActive': isActive,
    };
  }

  // Convert Firestore document to Course
  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      courseCode: data['courseCode'] ?? '',
      maxStudents: data['maxStudents'] ?? 0,
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      students:
          List<String>.from(data['students'] ?? []), // List of student IDs
      files: List<String>.from(data['files'] ?? []),
      canEnroll: data['canEnroll'] ?? true, // Default to true if not provided
      isActive: data['isActive'] ?? true,
    );
  }
}
