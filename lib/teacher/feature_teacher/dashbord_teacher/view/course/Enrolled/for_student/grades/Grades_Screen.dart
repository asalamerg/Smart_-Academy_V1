import 'package:flutter/material.dart';

import '../../../../../../../../cousrses/ControllerCourse.dart';

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
    final maxGradeText = maxGradeController.text.trim();

    if (examName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the exam name')),
      );
      return;
    }

    if (maxGradeText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the maximum grade')),
      );
      return;
    }

    final maxGrade = int.tryParse(maxGradeText);
    if (maxGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum grade must be a number')),
      );
      return;
    }

    Map<String, dynamic> grades = {};
    bool hasInvalidGrade = false;

    studentGradeControllers.forEach((studentId, controller) {
      final gradeText = controller.text.trim();
      final grade = int.tryParse(gradeText);

      if (grade == null && gradeText.isNotEmpty) {
        hasInvalidGrade = true;
        return;
      }

      grades[studentId] = grade ?? 0;
    });

    if (hasInvalidGrade) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please enter valid numeric grades for all students')),
      );
      return;
    }

    try {
      final controller = CourseController();

      await controller.saveGradesToStudentData(
        courseId: widget.courseId,
        examName: examName,
        maxGrade: maxGrade,
        grades: grades,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grades saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save grades: $e')),
      );
    }
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
                          decoration: const InputDecoration(
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
