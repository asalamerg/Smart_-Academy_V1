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
  double _overallGrade = 0.0;
  int _totalAbsences = 0;
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
          _errorMessage = 'معرّف الطالب غير صالح';
          _isLoading = false;
        });
        return;
      }

      final studentDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(studentId)
          .get();

      final courseData =
          await fetchStudentCourseData(studentId, widget.courseId);

      if (!mounted) return;

      setState(() {
        studentInfo = studentDoc.data();
        _processGrades(courseData['grades'] ?? {});
        _calculateTotalAbsences(courseData['attendance'] ?? {});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في جلب البيانات: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _processGrades(Map<String, dynamic> grades) {
    if (grades.isEmpty) {
      _overallGrade = 0.0;
      return;
    }

    double total = 0.0;
    int count = 0;

    grades.forEach((key, value) {
      final gradeValue = _parseGradeValue(value);
      if (gradeValue != null) {
        total += gradeValue;
        count++;
      }
    });

    _overallGrade = count > 0 ? (total / count) : 0.0;
  }

  double? _parseGradeValue(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      final numericValue = double.tryParse(value);
      if (numericValue != null) {
        return numericValue;
      }
    }

    if (value is Map) {
      try {
        final score = value['score'] ?? value['mark'] ?? value['grade'] ?? 0;
        final maxScore =
            value['maxScore'] ?? value['total'] ?? value['outOf'] ?? 1;

        final numScore = score is num
            ? score.toDouble()
            : double.tryParse(score.toString()) ?? 0;
        final numMaxScore = maxScore is num
            ? maxScore.toDouble()
            : double.tryParse(maxScore.toString()) ?? 1;

        if (numMaxScore == 0) return null;

        return (numScore / numMaxScore) * 100;
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  String _formatGradeValue(dynamic value) {
    final parsedValue = _parseGradeValue(value);
    if (parsedValue == null) return 'غير متاح';

    if (value is Map) {
      final score = value['score'] ?? value['mark'] ?? value['grade'] ?? '?';
      final maxScore =
          value['maxScore'] ?? value['total'] ?? value['outOf'] ?? '?';
      return '$score/$maxScore (${parsedValue.toStringAsFixed(1)}%)';
    }

    return '${parsedValue.toStringAsFixed(1)}%';
  }

  void _calculateTotalAbsences(Map<String, dynamic> attendance) {
    _totalAbsences = 0;
    attendance.forEach((key, value) {
      if (value.toString().toLowerCase() == 'absent' ||
          value.toString().toLowerCase() == 'غائب' ||
          value == false) {
        _totalAbsences++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentName = widget.student['name'] ?? 'غير معروف';
    final studentNumber = studentInfo?['numberId'] ?? 'غير متوفر';
    final studentEmail = studentInfo?['email'] ?? 'غير متوفر';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('تفاصيل الطالب',
            style: TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
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
                      _buildPerformanceSummary(),
                      const SizedBox(height: 24),
                      _buildGradesSection(),
                      const SizedBox(height: 24),
                      _buildAttendanceSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStudentCard(String name, String number, String email) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, color: Colors.blue.shade700),
              radius: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal')),
                  const SizedBox(height: 4),
                  Text('رقم الطالب: $number',
                      style: TextStyle(
                          color: Colors.grey.shade700, fontFamily: 'Tajawal')),
                  const SizedBox(height: 4),
                  Text('البريد: $email',
                      style: TextStyle(
                          color: Colors.grey.shade700, fontFamily: 'Tajawal')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('ملخص الأداء',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Tajawal')),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                    'المعدل',
                    '${_overallGrade.toStringAsFixed(1)}%',
                    Icons.grade,
                    _getGradeColor(_overallGrade)),
                _buildSummaryItem(
                    'أيام الغياب',
                    _totalAbsences.toString(),
                    Icons.calendar_today,
                    _totalAbsences > 0 ? Colors.orange : Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradesSection() {
    final grades = studentInfo?['grades'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('العلامات',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontFamily: 'Tajawal')),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: grades.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('لا توجد علامات مسجلة بعد',
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Tajawal')),
                    ),
                  )
                : Column(
                    children: [
                      ...grades.entries.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    e.key,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Tajawal'),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getGradeColor(
                                        _parseGradeValue(e.value) ?? 0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _formatGradeValue(e.value),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Tajawal'),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المعدل النهائي',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal')),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getGradeColor(_overallGrade),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_overallGrade.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceSection() {
    final attendance = studentInfo?['attendance'] ?? {};
    final absentDays = attendance.entries
        .where((e) =>
            e.value.toString().toLowerCase() == 'absent' ||
            e.value.toString().toLowerCase() == 'غائب' ||
            e.value == false)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('سجل الحضور',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontFamily: 'Tajawal')),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('إجمالي أيام الغياب',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Tajawal')),
                    Chip(
                      label: Text(
                        _totalAbsences.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: _totalAbsences > 0
                          ? Colors.red.shade600
                          : Colors.green.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (absentDays.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('لا توجد سجلات غياب',
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Tajawal')),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('أيام الغياب',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Tajawal')),
                      const SizedBox(height: 8),
                      ...absentDays.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.circle,
                                    color: Colors.red, size: 12),
                                const SizedBox(width: 8),
                                Text(_formatDate(e.key),
                                    style:
                                        const TextStyle(fontFamily: 'Tajawal')),
                              ],
                            ),
                          )),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 85) return Colors.green;
    if (grade >= 70) return Colors.lightGreen;
    if (grade >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _buildSummaryItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
          radius: 22,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }

  Future<Map<String, dynamic>> fetchStudentCourseData(
      String studentId, String courseId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('studentData')
          .doc(studentId)
          .get();

      return doc.exists ? doc.data() as Map<String, dynamic> : {};
    } catch (e) {
      debugPrint('Error fetching course data: $e');
      return {};
    }
  }
}
