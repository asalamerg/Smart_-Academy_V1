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
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController maxGradeController = TextEditingController();

  Map<String, TextEditingController> studentGradeControllers = {};

  @override
  void initState() {
    super.initState();
    for (var student in widget.students) {
      final id = student['id'] ?? student['name'];
      studentGradeControllers[id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    examNameController.dispose();
    maxGradeController.dispose();
    for (var controller in studentGradeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> saveGrades() async {
    final examName = examNameController.text.trim();
    final maxGrade = maxGradeController.text.trim();

    if (examName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the exam name')),
      );
      return;
    }

    if (maxGrade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the maximum grade')),
      );
      return;
    }

    Map<String, String> grades = {};
    studentGradeControllers.forEach((studentId, controller) {
      grades[studentId] = controller.text.trim();
    });

    // هنا يمكنك حفظ اسم الامتحان والدرجة القصوى مع درجات الطلاب في Firestore
    print('Exam Name: $examName');
    print('Max Grade: $maxGrade');
    print('Grades: $grades');

    // بعد الحفظ في قاعدة البيانات
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades saved successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grades'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: examNameController,
              decoration: const InputDecoration(
                labelText: 'Exam Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxGradeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Maximum Grade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: widget.students.length,
                itemBuilder: (context, index) {
                  final student = widget.students[index];
                  final studentId = student['id'] ?? student['name'];
                  final studentName = student['name'] ?? 'No Name';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(studentName),
                      trailing: SizedBox(
                        width: 80,
                        child: TextField(
                          controller: studentGradeControllers[studentId],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Grade',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
