import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> students;
  final String courseId;

  const GradesScreen(
      {super.key, required this.students, required this.courseId});

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  Map<String, TextEditingController> gradeControllers = {};

  @override
  void initState() {
    super.initState();
    for (var student in widget.students) {
      gradeControllers[student['id'] ?? student['name']] =
          TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in gradeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> saveGrades() async {
    // هنا تحفظ العلامات في قاعدة البيانات
    // مثلاً ارسل map من studentId -> gradeController.text
    Map<String, String> grades = {};
    gradeControllers.forEach((key, controller) {
      grades[key] = controller.text;
    });

    print("Grades to save: $grades");

    // TODO: أضف حفظ العلامات في Firestore هنا حسب تصميم قاعدة البيانات

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades saved successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Grades'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.students.length,
        itemBuilder: (context, index) {
          final student = widget.students[index];
          final studentId = student['id'] ?? student['name'];
          final studentName = student['name'] ?? 'No Name';

          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(studentName),
            trailing: SizedBox(
              width: 100,
              child: TextField(
                controller: gradeControllers[studentId],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Grade',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveGrades,
        label: const Text('Save Grades'),
        icon: const Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
