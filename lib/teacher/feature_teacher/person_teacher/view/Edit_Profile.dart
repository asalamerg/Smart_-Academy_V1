import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';

class EditProfile extends StatefulWidget {
  final ModelTeacher teacher;

  const EditProfile({super.key, required this.teacher});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing teacher data
    nameController.text = widget.teacher.name;
    emailController.text = widget.teacher.email;
    numberIdController.text = widget.teacher.numberId;
  }

  // Function to update the profile
  Future<void> updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update name and email
        await user.updateDisplayName(nameController.text);
        await user.updateEmail(emailController.text);

        // Update Firestore data
        await FirebaseFirestore.instance
            .collection('teachers')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'email': emailController.text,
          'numberId': numberIdController.text,
        });

        // Check if widget is still mounted before updating UI
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Profile updated successfully')));
          Navigator.pop(context); // Go back to the previous screen
        }
      }
    } catch (e) {
      // Check if widget is still mounted before updating UI
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Edit Name
              Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Edit Email
              Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              // Edit Number ID
              Text(
                'ID',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: numberIdController,
                decoration: InputDecoration(
                  hintText: "Enter your ID",
                  prefixIcon: Icon(Icons.perm_identity),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Save button
              Center(
                child: ElevatedButton(
                  onPressed: updateProfile,
                  child: Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
