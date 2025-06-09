import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  final String courseId;

  const StudentDetailScreen({
    super.key,
    required this.student,
    required this.courseId,
  });

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  Map<String, dynamic>? studentInfo;
  Map<String, dynamic>? studentGrades;
  Map<String, dynamic>? studentAttendance;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      final studentId = widget.student['id'] ?? '';
      if (studentId.isEmpty) {
        setState(() {
          _errorMessage = 'Invalid student ID';
          _isLoading = false;
        });
        return;
      }

      final studentDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(studentId)
          .get();

      final studentGradesDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('studentData')
          .doc(studentId)
          .get();

      final studentAttendanceDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('studentData')
          .doc(studentId)
          .get();

      if (!mounted) return;

      setState(() {
        studentInfo = studentDoc.data();
        studentGrades = studentGradesDoc.data()?['grades'];
        studentAttendance = studentAttendanceDoc.data()?['attendance'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  double calculatePercentage(double grade, double maxGrade) {
    if (maxGrade == 0) return 0.0;
    return (grade / maxGrade) * 100;
  }

  // Update Grade Function
  Future<void> _updateGrade(
      String gradeName, double newGrade, double newMaxGrade) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('studentData')
          .doc(widget.student['id'])
          .update({
        'grades.$gradeName': {
          'grade': newGrade,
          'maxGrade': newMaxGrade,
        },
      });

      await _fetchStudentData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating grade: $e')),
      );
    }
  }

  // Delete Attendance Function
  Future<void> _deleteAttendance(String date) async {
    try {
      final safeKey = date.replaceAll('.', '_');
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('studentData')
          .doc(widget.student['id'])
          .update({
        'attendance.$safeKey': FieldValue.delete(),
      });

      await _fetchStudentData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Attendance record deleted successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting attendance: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Dialog for editing grades
  Future<void> _showEditGradeDialog(
      String gradeName, double currentGrade, double currentMaxGrade) {
    TextEditingController gradeController =
        TextEditingController(text: currentGrade.toString());
    TextEditingController maxGradeController =
        TextEditingController(text: currentMaxGrade.toString());

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Grade: $gradeName',
              style: TextStyle(fontFamily: 'Tajawal')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: gradeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Grade',
                  hintText: 'Enter grade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxGradeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Grade',
                  hintText: 'Enter max grade',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(fontFamily: 'Tajawal')),
            ),
            ElevatedButton(
              onPressed: () async {
                double newGrade =
                    double.tryParse(gradeController.text) ?? currentGrade;
                double newMaxGrade =
                    double.tryParse(maxGradeController.text) ?? currentMaxGrade;
                await _updateGrade(gradeName, newGrade, newMaxGrade);
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(fontFamily: 'Tajawal')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentName = widget.student['name'] ?? 'Unknown';
    final studentNumber = studentInfo?['numberId'] ?? 'Not available';
    final studentEmail = studentInfo?['email'] ?? 'Not available';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Details',
            style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.red.shade400),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontFamily: 'Tajawal'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchStudentData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Retry',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Tajawal')),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStudentCard(
                          studentName, studentNumber, studentEmail),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Grades Summary'),
                      const SizedBox(height: 12),
                      _buildGradesSection(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Attendance Records'),
                      const SizedBox(height: 12),
                      _buildAttendanceSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
        fontFamily: 'Tajawal',
      ),
    );
  }

  Widget _buildStudentCard(String name, String number, String email) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      shadowColor: Colors.blue.shade100,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade50,
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 36,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.badge, 'ID: $number'),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.email, 'Email: $email'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey.shade600),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: 'Tajawal',
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildGradesSection() {
    if (studentGrades == null || studentGrades!.isEmpty) {
      return _buildEmptyState(
        icon: Icons.assignment_outlined,
        message: 'No grades available for this student',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ...studentGrades!.entries.map((entry) {
            final gradeName = entry.key;
            final gradeData = entry.value;
            double grade = (gradeData['grade'] ?? 0.0).toDouble();
            double maxGrade = (gradeData['maxGrade'] ?? 0.0).toDouble();
            double percentage = calculatePercentage(grade, maxGrade);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          gradeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      Text(
                        '${grade.toString()}/${maxGrade.toString()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit,
                            size: 20, color: Colors.blue),
                        onPressed: () {
                          _showEditGradeDialog(gradeName, grade, maxGrade);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(percentage)),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        _getGradeStatus(percentage),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getProgressColor(percentage),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getGradeStatus(double percentage) {
    if (percentage >= 85) return 'Excellent';
    if (percentage >= 70) return 'Good';
    if (percentage >= 50) return 'Average';
    return 'Needs Improvement';
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 85) return Colors.green.shade600;
    if (percentage >= 70) return Colors.lightGreen.shade500;
    if (percentage >= 50) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  // Additional Functions

  Widget _buildAttendanceSection() {
    if (studentAttendance == null || studentAttendance!.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today_outlined,
        message: 'No attendance records available',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ...studentAttendance!.entries.map((entry) {
            final date = entry.key;
            final status = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _formatDate(date),
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: status == 'Absent'
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: status == 'Absent'
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == 'Absent' ? Icons.close : Icons.check,
                              size: 16,
                              color: status == 'Absent'
                                  ? Colors.red.shade600
                                  : Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status == 'Absent' ? 'Absent' : 'Present',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: status == 'Absent'
                                    ? Colors.red.shade600
                                    : Colors.green.shade600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            size: 20, color: Colors.grey.shade500),
                        onPressed: () => _showDeleteDialog(date),
                        tooltip: 'Delete Attendance',
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.5),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(String date) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Attendance',
              style: TextStyle(fontFamily: 'Tajawal')),
          content: Text(
              'Are you sure you want to delete attendance record for ${_formatDate(date)}?',
              style: const TextStyle(fontFamily: 'Tajawal')),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
              child:
                  const Text('Cancel', style: TextStyle(fontFamily: 'Tajawal')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade600,
              ),
              child:
                  const Text('Delete', style: TextStyle(fontFamily: 'Tajawal')),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAttendance(date);
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final formatter = DateFormat('EEEE, d MMMM yyyy', 'ar');
      return formatter.format(date);
    } catch (e) {
      return timestamp.length >= 10 ? timestamp.substring(0, 10) : timestamp;
    }
  }
}
