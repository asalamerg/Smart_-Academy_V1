import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/firebase_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view/login_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view_model/auth_bloc_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/person_teacher/view/Edit_Profile.dart';

class PersonTeacher extends StatefulWidget {
  @override
  State<PersonTeacher> createState() => _PersonTeacherState();
}

class _PersonTeacherState extends State<PersonTeacher> {
  @override
  Widget build(BuildContext context) {
    final teacher = BlocProvider.of<AuthBlocTeacher>(context).modelTeacher;

    // إذا كانت بيانات المعلم غير موجودة، نعرض رسالة للمستخدم.
    if (teacher == null) {
      return Scaffold(
        body: Center(child: Text("No teacher data available")),
      );
    }

    final displaySmall = Theme.of(context).textTheme.displaySmall;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض الاسم في بطاقة مع أيقونة
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text('Name',
                      style:
                          displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    teacher.name,
                    style: displaySmall?.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              SizedBox(height: 20),

              // عرض البريد الإلكتروني في بطاقة مع أيقونة
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text('Email',
                      style:
                          displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    teacher.email,
                    style: displaySmall?.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.email, color: Colors.blue),
                ),
              ),
              SizedBox(height: 20),

              // عرض رقم المعرف في بطاقة مع أيقونة
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text('ID',
                      style:
                          displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    teacher.numberId,
                    style: displaySmall?.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.perm_identity, color: Colors.blue),
                ),
              ),
              SizedBox(height: 40),

              // زر تسجيل الخروج
              Center(
                child: InkWell(
                  onTap: logoutTeacher,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.logout, size: 30, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // زر تعديل البيانات
              // Center(
              //   child: InkWell(

              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => EditProfile(teacher: teacher),
              //         ),
              //       );
              //     },
              //     child: Container(
              //       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              //       decoration: BoxDecoration(
              //         color: Colors.green,
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             "Edit Profile",
              //             style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           SizedBox(width: 10),
              //           Icon(Icons.edit, size: 30, color: Colors.white),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لتسجيل الخروج
  void logoutTeacher() {
    FunctionFirebaseTeacher.logoutTeacher(); // دالة تسجيل الخروج
    Navigator.of(context).pushReplacementNamed(
        LoginTeacher.routeName); // إعادة التوجيه إلى صفحة تسجيل الدخول
  }
}
