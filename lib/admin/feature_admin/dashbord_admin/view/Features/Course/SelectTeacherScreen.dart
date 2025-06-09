import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectTeacherScreen extends StatefulWidget {
  const SelectTeacherScreen({super.key});

  @override
  _SelectTeacherScreenState createState() => _SelectTeacherScreenState();
}

class _SelectTeacherScreenState extends State<SelectTeacherScreen> {
  List<Map<String, dynamic>> _teachers = []; // List to store teachers
  List<Map<String, dynamic>> _filteredTeachers = []; // Filtered teachers list
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTeachers(); // Fetch teachers when the screen is initialized
  }

  // Fetch teachers from Firestore
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
        _filteredTeachers = _teachers; // Initialize filtered list
      });
    } catch (e) {
      print("Error fetching teachers: $e");
    }
  }

  // Filter teachers based on search query
  void _filterTeachers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTeachers = _teachers;
      } else {
        _filteredTeachers = _teachers.where((teacher) {
          final teacherName = teacher['name'].toLowerCase();
          final teacherEmail = teacher['email'].toLowerCase();
          final searchQuery = query.toLowerCase();
          return teacherName.contains(searchQuery) ||
              teacherEmail.contains(searchQuery);
        }).toList();
      }
    });
  }

  // Navigate to CreateCourseScreen with the selected teacher ID
  void _selectTeacher(String teacherId) {
    Navigator.pop(context,
        teacherId); // Pass selected teacherId back to CreateCourseScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Teacher"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterTeachers,
                decoration: InputDecoration(
                  hintText: 'ابحث باسم المعلم أو البريد الإلكتروني...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[500]),
                          onPressed: () {
                            _searchController.clear();
                            _filterTeachers('');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            // List of teachers
            _filteredTeachers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filteredTeachers.length,
                      itemBuilder: (context, index) {
                        final teacher = _filteredTeachers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              teacher['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              teacher['email'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onTap: () => _selectTeacher(teacher['id']),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
