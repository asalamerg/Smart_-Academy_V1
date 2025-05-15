import 'package:flutter/material.dart';
import 'package:smart_academy/cousrses/ControllerCourse.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';

class AddCourseScreen extends StatefulWidget {
  final ModelTeacher teacher;

  const AddCourseScreen({super.key, required this.teacher});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();
  List<String> selectedDays = [];
  bool canEnroll = true; // Default value for canEnroll
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

  // Save the course
  void _saveCourse() async {
    final name = nameController.text.trim();
    final start = startTimeController.text.trim();
    final end = endTimeController.text.trim();
    final capacity = int.tryParse(capacityController.text.trim()) ?? 0;
    final courseCode = courseCodeController.text.trim();

    // Example file URLs
    List<String> files = ['https://example.com/file1.pdf'];

    // List of students (empty initially)
    List<String> students = [];

    if (name.isNotEmpty &&
        start.isNotEmpty &&
        end.isNotEmpty &&
        selectedDays.isNotEmpty &&
        courseCode.isNotEmpty) {
      await _courseController.addCourse(
        teacher: widget.teacher,
        name: name,
        description: 'Course description goes here',
        pdfUrl: 'https://example.com/sample.pdf',
        courseCode: courseCode,
        maxStudents: capacity,
        startTime: start,
        endTime: end,
        days: selectedDays,
        files: files,
        students: students, // List of students
        canEnroll: canEnroll, // Add canEnroll to the course
      );

      Navigator.pop(context); // Go back after saving
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Course Saved!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: Text("Add New Course"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Name Field
              _buildTextField(nameController, "Course Name", Icons.book),

              // Course Code Field
              _buildTextField(courseCodeController, "Course Code", Icons.code),

              // Start Time Field
              _buildTextField(
                  startTimeController, "Start Time (HH:mm)", Icons.access_time),

              // End Time Field
              _buildTextField(
                  endTimeController, "End Time (HH:mm)", Icons.access_time),

              // Capacity Field
              _buildTextField(capacityController, "Capacity", Icons.people),

              // Days Selection
              _buildDaysSelection(),

              // Can Enroll Toggle
              _buildCanEnrollSwitch(),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCourse,
                child: Text("Save Course"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
          Text(
            "Allow Students to Enroll",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
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
