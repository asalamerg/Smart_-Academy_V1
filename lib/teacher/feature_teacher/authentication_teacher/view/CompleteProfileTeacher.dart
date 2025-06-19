import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/screen_home_teacher/view/screen_home_teacher.dart';

class CompleteProfileTeacherScreen extends StatefulWidget {
  final String teacherId;

  const CompleteProfileTeacherScreen({Key? key, required this.teacherId})
      : super(key: key);

  @override
  _CompleteProfileTeacherScreenState createState() =>
      _CompleteProfileTeacherScreenState();
}

class _CompleteProfileTeacherScreenState
    extends State<CompleteProfileTeacherScreen> {
  final TextEditingController _numberIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _numberIdController,
              decoration: InputDecoration(labelText: 'Enter Your Number ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Update numberId and email in Firestore
                  await FirebaseFirestore.instance
                      .collection('teacher')
                      .doc(widget.teacherId)
                      .update({
                    'numberId': _numberIdController.text,
                    'email': FirebaseAuth.instance.currentUser?.email,
                  });

                  // Navigate to home screen after profile completion
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreenTeacher(
                        modelTeacher: ModelTeacher(
                          id: widget.teacherId,
                          name:
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  "No Name",
                          email: FirebaseAuth.instance.currentUser?.email ??
                              "No Email",
                          numberId: _numberIdController.text,
                        ),
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save numberId: $e')),
                  );
                }
              },
              child: const Text('Save and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
