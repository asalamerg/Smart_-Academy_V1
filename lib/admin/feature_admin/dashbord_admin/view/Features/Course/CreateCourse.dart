import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/cousrses/ControllerCourse.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/controller/teacher.dart';
import 'SelectTeacherScreen.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  _CreateCourseScreenState createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();
  List<String> selectedDays = [];
  bool canEnroll = true;
  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  CourseController _courseController = CourseController();
  TeacherController _teacherController = TeacherController();

  String? _selectedTeacherId;
  List<Map<String, dynamic>> _teachers = [];

  Future<void> _fetchTeachers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('teacher').get();
      setState(() {
        _teachers = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'email': doc['email'],
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching teachers: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTeachers();
  }

  void _saveCourse() async {
    final name = nameController.text.trim();
    final start = startTimeController.text.trim();
    final end = endTimeController.text.trim();
    final capacity = int.tryParse(capacityController.text.trim()) ?? 0;
    final courseCode = courseCodeController.text.trim();
    bool isActive = true;
    bool canEnroll = true;

    List<String> files = ['https://example.com/file1.pdf'];
    // List<String> students = [];

    if (name.isNotEmpty &&
        start.isNotEmpty &&
        end.isNotEmpty &&
        selectedDays.isNotEmpty &&
        courseCode.isNotEmpty &&
        _selectedTeacherId != null) {
      try {
        ModelTeacher teacher =
            await _teacherController.getTeacherById(_selectedTeacherId!);
        await _courseController.addCourse(
          teacher: teacher,
          name: name,
          description: 'Course description goes here',
          pdfUrl: 'https://example.com/sample.pdf',
          courseCode: courseCode,
          maxStudents: capacity,
          startTime: start,
          endTime: end,
          days: selectedDays,
          files: files,
          // students: students,
          canEnroll: canEnroll,
          isActive: isActive,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Course Saved!')));
      } catch (e) {
        print('Error fetching teacher or saving course: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create New Course"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher Selection Button
              ElevatedButton(
                onPressed: () async {
                  final teacherId = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectTeacherScreen(),
                    ),
                  );
                  if (teacherId != null) {
                    setState(() {
                      _selectedTeacherId = teacherId;
                    });
                  }
                },
                child: Text(
                  _selectedTeacherId == null
                      ? "Select Teacher"
                      : "Teacher Selected",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Course Fields
              _buildTextField(nameController, "Course Name", Icons.book),
              _buildTextField(courseCodeController, "Course Code", Icons.code),
              _buildTextField(
                  startTimeController, "Start Time (HH:mm)", Icons.access_time),
              _buildTextField(
                  endTimeController, "End Time (HH:mm)", Icons.access_time),
              _buildTextField(capacityController, "Capacity", Icons.people),

              const SizedBox(height: 16),

              // Days Selection
              _buildDaysSelection(),
              _buildCanEnrollSwitch(),

              const SizedBox(height: 20),
              // Save Course Button
              ElevatedButton(
                onPressed: _saveCourse,
                child: Text("Save Course"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create text fields
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Function to select days of the week
  Widget _buildDaysSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Days",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...daysOfWeek.map((day) {
            return CheckboxListTile(
              title: Text(day),
              value: selectedDays.contains(day),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    selectedDays.add(day);
                  } else {
                    selectedDays.remove(day);
                  }
                });
              },
              activeColor: Colors.blue,
              checkColor: Colors.white,
            );
          }).toList(),
        ],
      ),
    );
  }

  // Function to toggle Can Enroll
  Widget _buildCanEnrollSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("Allow Students to Enroll",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Switch(
            value: canEnroll,
            onChanged: (value) {
              setState(() {
                canEnroll = value;
              });
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
