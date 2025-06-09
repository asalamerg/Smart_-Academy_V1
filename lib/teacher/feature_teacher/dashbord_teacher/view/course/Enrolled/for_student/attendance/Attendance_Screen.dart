import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  final List<Map<String, dynamic>> students;
  final String courseId;

  const AttendanceScreen(
      {super.key, required this.students, required this.courseId});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<String, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    for (var student in widget.students) {
      attendance[student['id'] ?? student['name']] = false;
    }
  }

  // دالة لحفظ أيام الغياب فقط
  Future<void> saveAttendance() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // حفظ الحضور فقط للطلاب الغائبين
    for (var entry in attendance.entries) {
      final studentId = entry.key;
      final isPresent = entry.value;

      // قم بحفظ الحضور فقط إذا كان الطالب غائبًا
      if (!isPresent) {
        await firestore
            .collection('courses')
            .doc(widget.courseId)
            .collection('studentData')
            .doc(studentId)
            .set({
          'attendance': {
            DateTime.now().toIso8601String(): 'Absent', // حفظ الغياب
          }
        }, SetOptions(merge: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.students.length,
        itemBuilder: (context, index) {
          final student = widget.students[index];
          final studentId = student['id'] ?? student['name'];
          final studentName = student['name'] ?? 'No Name';
          final isPresent = attendance[studentId] ?? false;

          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(studentName),
            trailing: Switch(
              value: isPresent,
              onChanged: (val) {
                setState(() {
                  attendance[studentId] = val;
                });
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await saveAttendance(); // حفظ البيانات
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Attendance saved successfully')),
          );
          Navigator.pop(context);
        },
        label: const Text('Save Attendance'),
        icon: const Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
