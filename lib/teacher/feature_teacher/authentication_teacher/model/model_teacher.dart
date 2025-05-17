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

  // تحويل الكائن إلى JSON ليتم تخزينه في قاعدة البيانات أو استخدامه في الشبكات
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'numberId': numberId,
    };
  }

  // تحويل JSON إلى كائن ModelTeacher
  ModelTeacher.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        numberId = json['numberId'];
}
