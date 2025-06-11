import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/admin/feature_admin/dashbord_admin/view/Features/Course/CourseDetail.dart';

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String searchQuery = ''; // Variable to hold search query

  // Function to update search query
  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure the background is white
      appBar: AppBar(
        title: const Text('Courses',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with rounded corners and internal padding
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            // Courses List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .where(
                      'isdelet',
                      isEqualTo: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(); // Display empty state
                  }

                  final courses = snapshot.data!.docs;
                  final filteredCourses = courses.where((course) {
                    final courseData = course.data() as Map<String, dynamic>;
                    final courseName = courseData.containsKey('name')
                        ? courseData['name']
                        : 'No Name';
                    return courseName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      final courseData = course.data() as Map<String, dynamic>;
                      final courseName = courseData.containsKey('name')
                          ? courseData['name']
                          : 'No Name';
                      final courseCode = courseData.containsKey('courseCode')
                          ? courseData['courseCode']
                          : 'No Code';
                      final courseDescription =
                          courseData.containsKey('description')
                              ? courseData['description']
                              : 'No Description';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigate to Course Detail Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailScreen(courseId: course.id),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            title: Text(courseName,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Code: $courseCode\nDescription: $courseDescription'),
                            trailing: Icon(Icons.arrow_forward,
                                color: Colors.blue.shade700),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display an empty state when no courses are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.grey, size: 72),
          const SizedBox(height: 16),
          Text('No courses found',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          Text('Try searching with a different query',
              style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
