class ModelUser {
  String id;
  String name;
  String email;
  String numberId;
  List<String> courses; // قائمة الكورسات المسجل فيها الطالب

  ModelUser({
    required this.id,
    required this.name,
    required this.email,
    required this.numberId,
    required this.courses, // تضمين الكورسات
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "numberId": numberId,
        "courses": courses, // إضافة الكورسات في الـ Json
      };

  ModelUser.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
          email: json['email'],
          numberId: json['numberId'],
          courses: List<String>.from(
              json['courses'] ?? []), // استرجاع الكورسات من الـ JSON
        );
}
