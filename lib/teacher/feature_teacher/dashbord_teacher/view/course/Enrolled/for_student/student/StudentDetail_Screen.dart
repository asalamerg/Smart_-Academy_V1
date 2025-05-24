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
  Map<String, dynamic> courseData = {};
  double _overallGrade = 0.0;
  int _totalAbsences = 0;
  List<MapEntry<String, dynamic>> _attendanceEntries = [];
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

      final courseDataResult =
          await fetchStudentCourseData(studentId, widget.courseId);

      if (!mounted) return;

      setState(() {
        studentInfo = studentDoc.data();
        courseData = courseDataResult;
        _processGrades(courseData['grades'] ?? {});
        _processAttendance(courseData['attendance'] ?? {});
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

  void _processAttendance(Map<String, dynamic> attendance) {
    _totalAbsences = 0;
    _attendanceEntries.clear();

    attendance.forEach((key, value) {
      _attendanceEntries.add(MapEntry(key, value));
      if (value.toString().toLowerCase() == 'absent' ||
          value.toString().toLowerCase() == 'غائب' ||
          value == false) {
        _totalAbsences++;
      }
    });

    // ترتيب التواريخ من الأحدث إلى الأقدم
    _attendanceEntries.sort((a, b) => b.key.compareTo(a.key));
  }

  void _showAddAttendanceDialog(BuildContext context) {
    DateTime? selectedDate;
    bool isAbsent = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة سجل حضور',
            style: TextStyle(fontFamily: 'Tajawal')),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    locale: const Locale('ar'),
                  );
                  if (pickedDate != null) {
                    setDialogState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  selectedDate == null
                      ? 'اختر التاريخ'
                      : _formatDate(selectedDate!.toIso8601String()),
                  style: const TextStyle(
                      fontFamily: 'Tajawal', color: Colors.blue),
                ),
              ),
              ListTile(
                title:
                    const Text('حاضر', style: TextStyle(fontFamily: 'Tajawal')),
                leading: Radio<bool>(
                  value: false,
                  groupValue: isAbsent,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        isAbsent = value;
                      });
                    }
                  },
                ),
              ),
              ListTile(
                title:
                    const Text('غائب', style: TextStyle(fontFamily: 'Tajawal')),
                leading: Radio<bool>(
                  value: true,
                  groupValue: isAbsent,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        isAbsent = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى اختيار تاريخ',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final timestampKey = selectedDate!.toIso8601String();
              try {
                await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(widget.courseId)
                    .collection('studentData')
                    .doc(widget.student['id'])
                    .update({
                  'attendance.$timestampKey': isAbsent ? 'Absent' : 'Present',
                });

                await _fetchStudentData();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة سجل الحضور بنجاح',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('خطأ أثناء إضافة الحضور: $e',
                        style: const TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('إضافة', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _showDeleteAttendanceDialog(BuildContext context, String timestamp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            const Text('تأكيد الحذف', style: TextStyle(fontFamily: 'Tajawal')),
        content: Text(
          'هل أنت متأكد من حذف سجل الحضور لتاريخ ${_formatDate(timestamp)}؟',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // إنشاء مفتاح آمن لـ Firestore باستبدال النقاط
                final safeKey = timestamp.replaceAll('.', '_');
                await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(widget.courseId)
                    .collection('studentData')
                    .doc(widget.student['id'])
                    .update({
                  'attendance.$safeKey': FieldValue.delete(),
                });

                await _fetchStudentData();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف سجل الحضور بنجاح',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('خطأ أثناء حذف الحضور: $e',
                        style: const TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('تأكيد', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _showEditGradeDialog(
      BuildContext context, String gradeKey, dynamic gradeValue) {
    final scoreController = TextEditingController(
        text: gradeValue is Map
            ? gradeValue['score']?.toString() ?? ''
            : gradeValue.toString());
    final maxScoreController = TextEditingController(
        text: gradeValue is Map
            ? gradeValue['maxScore']?.toString() ?? ''
            : '100');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل العلامة: $gradeKey',
            style: const TextStyle(fontFamily: 'Tajawal')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الدرجة',
                hintText: 'أدخل الدرجة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxScoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الدرجة القصوى',
                hintText: 'أدخل الدرجة القصوى',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () async {
              final score = double.tryParse(scoreController.text);
              final maxScore = double.tryParse(maxScoreController.text);
              if (score == null || maxScore == null || maxScore == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى إدخال قيم صالحة',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(widget.courseId)
                    .collection('studentData')
                    .doc(widget.student['id'])
                    .update({
                  'grades.$gradeKey': {
                    'score': score,
                    'maxScore': maxScore,
                  },
                });

                await _fetchStudentData();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تعديل العلامة بنجاح',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('خطأ أثناء تعديل العلامة: $e',
                        style: const TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('حفظ', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
  }

  void _showAddGradeDialog(BuildContext context) {
    final gradeNameController = TextEditingController();
    final scoreController = TextEditingController();
    final maxScoreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة علامة جديدة',
            style: TextStyle(fontFamily: 'Tajawal')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: gradeNameController,
              decoration: const InputDecoration(
                labelText: 'اسم العلامة',
                hintText: 'مثال: اختبار 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الدرجة',
                hintText: 'أدخل الدرجة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxScoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الدرجة القصوى',
                hintText: 'أدخل الدرجة القصوى',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            onPressed: () async {
              final gradeName = gradeNameController.text.trim();
              final score = double.tryParse(scoreController.text);
              final maxScore = double.tryParse(maxScoreController.text);

              if (gradeName.isEmpty ||
                  score == null ||
                  maxScore == null ||
                  maxScore == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يرجى إدخال جميع الحقول بقيم صالحة',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await FirebaseFirestore.instance
                    .collection('courses')
                    .doc(widget.courseId)
                    .collection('studentData')
                    .doc(widget.student['id'])
                    .update({
                  'grades.$gradeName': {
                    'score': score,
                    'maxScore': maxScore,
                  },
                });

                await _fetchStudentData();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إضافة العلامة بنجاح',
                        style: TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('خطأ أثناء إضافة العلامة: $e',
                        style: const TextStyle(fontFamily: 'Tajawal')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('إضافة', style: TextStyle(fontFamily: 'Tajawal')),
          ),
        ],
      ),
    );
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
    final grades = courseData['grades'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('العلامات',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Tajawal')),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              onPressed: () => _showAddGradeDialog(context),
              tooltip: 'إضافة علامة جديدة',
            ),
          ],
        ),
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
                                Row(
                                  children: [
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
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          size: 20, color: Colors.blue),
                                      onPressed: () => _showEditGradeDialog(
                                          context, e.key, e.value),
                                      tooltip: 'تعديل العلامة',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      if (grades.isNotEmpty) ...[
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
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('سجل الحضور',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Tajawal')),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              onPressed: () => _showAddAttendanceDialog(context),
              tooltip: 'إضافة سجل حضور',
            ),
          ],
        ),
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
                const SizedBox(height: 16),
                if (_attendanceEntries.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 48),
                          SizedBox(height: 8),
                          Text('لا توجد سجلات حضور مسجلة',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Tajawal',
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.event, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          const Text('سجلات الحضور',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                  fontFamily: 'Tajawal')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: _attendanceEntries
                              .map((entry) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          entry.value
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'absent' ||
                                                  entry.value
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'غائب' ||
                                                  entry.value == false
                                              ? Icons.event_busy
                                              : Icons.event_available,
                                          color: entry.value
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'absent' ||
                                                  entry.value
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'غائب' ||
                                                  entry.value == false
                                              ? Colors.red.shade600
                                              : Colors.green.shade600,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _formatDate(entry.key),
                                            style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                fontSize: 15,
                                                color: entry.value
                                                                .toString()
                                                                .toLowerCase() ==
                                                            'absent' ||
                                                        entry.value
                                                                .toString()
                                                                .toLowerCase() ==
                                                            'غائب' ||
                                                        entry.value == false
                                                    ? Colors.red.shade700
                                                    : Colors.green.shade700),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: entry
                                                            .value
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'absent' ||
                                                    entry.value
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'غائب' ||
                                                    entry.value == false
                                                ? Colors.red.shade600
                                                : Colors.green.shade600,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            entry.value
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'absent' ||
                                                    entry.value
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'غائب' ||
                                                    entry.value == false
                                                ? 'غائب'
                                                : 'حاضر',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontFamily: 'Tajawal'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 18, color: Colors.red),
                                          onPressed: () =>
                                              _showDeleteAttendanceDialog(
                                                  context, entry.key),
                                          tooltip: 'حذف سجل الحضور',
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
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

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final formatter = DateFormat('EEEE، d MMMM yyyy', 'ar');
      return formatter.format(date);
    } catch (e) {
      return timestamp.length >= 10 ? timestamp.substring(0, 10) : timestamp;
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
