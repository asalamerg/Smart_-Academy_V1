import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // استيراد FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد Firestore
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/dashbord_teacher/view/dashbord_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/person_teacher/view/person_teacher.dart';

class HomeScreenTeacher extends StatefulWidget {
  static const String routeName = "HomeScreenTeacher";

  const HomeScreenTeacher({super.key});

  @override
  State<HomeScreenTeacher> createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends State<HomeScreenTeacher> {
  int select = 0; // التحكم في التبويبات
  late Future<ModelTeacher> teacherFuture;

  @override
  void initState() {
    super.initState();
    teacherFuture =
        _getTeacherData(); // جلب بيانات المعلم عند بداية تحميل الصفحة
  }

  // دالة لجلب بيانات المعلم من Firebase
  Future<ModelTeacher> _getTeacherData() async {
    try {
      User? user = FirebaseAuth
          .instance.currentUser; // الحصول على المستخدم الحالي من FirebaseAuth
      if (user != null) {
        // إذا كان هناك مستخدم مسجل دخول
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(user.uid)
            .get();

        // إذا كان مستند المستخدم موجودًا في Firestore
        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          return ModelTeacher(
            id: user.uid,
            name: user.displayName ??
                "No Name", // التأكد من تعيين "No Name" إذا لم يكن هناك اسم
            email: user.email ??
                "No Email", // عرض البريد الإلكتروني أو "No Email" إذا لم يكن موجودًا
            numberId: data['numberId'] ?? "No ID", // جلب numberId من Firestore
          );
        } else {
          // إذا لم يتم العثور على بيانات المستخدم في Firestore
          return ModelTeacher(
            id: user.uid,
            name: user.displayName ?? "No Name",
            email: user.email ?? "No Email",
            numberId: "No ID", // وضع قيمة افتراضية في حال عدم وجود numberId
          );
        }
      }
      throw Exception('User not found'); // إذا لم يكن هناك مستخدم
    } catch (e) {
      throw Exception('Error fetching user data: $e'); // التعامل مع الأخطاء
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ModelTeacher>(
      future: teacherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // عرض دائرة تحميل أثناء جلب البيانات
        }

        if (snapshot.hasError) {
          return Center(
              child: Text(
                  'Error: ${snapshot.error}')); // عرض رسالة خطأ في حال حدوث مشكلة
        }

        if (snapshot.hasData) {
          ModelTeacher teacher = snapshot.data!; // جلب بيانات المعلم

          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/background.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                leading: Container(),
                title: Text(
                  'Home Screen',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                centerTitle: true,
              ),
              body: select == 0
                  ? DashbordTeacher(
                      teacher: teacher,
                    )
                  : PersonTeacher(), // تمرير بيانات المعلم إلى DashbordTeacher أو PersonTeacher
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: select,
                onTap: (index) {
                  setState(() {
                    select = index; // تغيير التبويب عند الضغط
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Person Info',
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
            child: Text('No data found')); // في حال لم يتم العثور على بيانات
      },
    );
  }
}
