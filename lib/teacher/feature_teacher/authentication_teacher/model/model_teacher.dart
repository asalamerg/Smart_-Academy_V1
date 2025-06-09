// lib/teacher/feature_teacher/model_teacher.dart

class ModelTeacher {
  String id;
  String name;
  String email;
  String numberId;

  // Constructor
  ModelTeacher({
    required this.id,
    required this.name,
    required this.email,
    required this.numberId,
  });

  // Convert the object to JSON for storing in the database or network use
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'numberId': numberId,
    };
  }

  // Convert JSON to a ModelTeacher object
  ModelTeacher.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        numberId = json['numberId'];

  // Method to update teacher details
}
