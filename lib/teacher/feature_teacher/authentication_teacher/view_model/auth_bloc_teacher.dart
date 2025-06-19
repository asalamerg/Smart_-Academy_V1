import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_academy/student/feature/authentication/view/screen_ui/register/CompleteProfile.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/firebase_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view/CompleteProfileTeacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view_model/auth_teacher_state.dart';
import 'package:smart_academy/teacher/feature_teacher/screen_home_teacher/view/screen_home_teacher.dart';

import '../../../../student/feature/authentication/view_model/auth_status.dart';

class AuthBlocTeacher extends Cubit<AuthStatusTeacher> {
  AuthBlocTeacher() : super(AuthInitialTeacher());

  ModelTeacher? modelTeacher;

  // دالة لتسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<void> loginViewModelTeacher(
      {required String email, required String password}) async {
    emit(LoginAuthLoadingTeacher());
    try {
      modelTeacher =
          await FunctionFirebaseTeacher.loginAccountTeacher(email, password);
      emit(LoginAuthSuccessTeacher());
    } catch (e) {
      emit(LoginAuthErrorTeacher(error: e.toString()));
    }
  }

  // دالة لتسجيل معلم جديد
  Future<void> registerViewModelTeacher({
    required String name,
    required String password,
    required String numberId,
    required String email,
  }) async {
    emit(RegisterAuthLoadingTeacher());
    try {
      modelTeacher = await FunctionFirebaseTeacher.registerAccountTeacher(
          email, name, numberId, password);
      emit(RegisterAuthSuccessTeacher());
    } catch (e) {
      emit(RegisterAuthErrorTeacher(error: e.toString()));
    }
  }

  Future<void> signInWithGoogleTeacher(BuildContext context) async {
    try {
      // بدء عملية تسجيل الدخول بجوجل
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // التحقق من وجود حساب جوجل
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("يجب اختيار حساب جوجل للمتابعة")),
        );
        return;
      }

      // إذا كانت بيانات المصادقة متاحة
      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // تسجيل الدخول باستخدام بيانات الاعتماد
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          // التحقق من وجود المستخدم في قاعدة البيانات
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection(
                  'teacher') // تأكد من أن اسم المجموعة صحيح (teacher أم teachers)
              .doc(firebaseUser.uid)
              .get();

          // إذا كان المستخدم غير موجود في قاعدة البيانات
          if (!userDoc.exists) {
            // إنشاء نموذج المستخدم بدون حفظ البريد الإلكتروني
            ModelTeacher modelUser = ModelTeacher(
              id: firebaseUser.uid,
              name: googleUser.displayName ?? "مستخدم جديد",
              email: "", // لن نحفظ البريد الإلكتروني هنا
              numberId: "", // سيتم تعبئته لاحقاً
            );

            // إضافة المعلم إلى Firestore بدون البريد الإلكتروني
            await FirebaseFirestore.instance
                .collection('teacher')
                .doc(modelUser.id)
                .set({
              'name': modelUser.name,
              'numberId': modelUser.numberId,
              // لا نضيف حقل البريد الإلكتروني هنا
              'createdAt': FieldValue.serverTimestamp(),
            });

            // توجيه المستخدم لصفحة إكمال الملف الشخصي
            emit(GoogleUserNeedsProfileCompletionTeacher());
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CompleteProfileTeacherScreen(
                  teacherId: modelUser.id,
                ),
              ),
            );
          } else {
            // إذا كان المستخدم موجوداً في النظام
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreenTeacher(
                  modelTeacher: ModelTeacher(
                    id: firebaseUser.uid,
                    name: userDoc['name'] ?? firebaseUser.displayName ?? "",
                    email: "", // لا نستخدم البريد الإلكتروني المحفوظ
                    numberId: userDoc['numberId'] ?? "",
                  ),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print("خطأ في تسجيل الدخول بجوجل: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء تسجيل الدخول: ${e.toString()}")),
      );
    }
  }

  // دالة لتسجيل الدخول عبر Google
  Future<void> signInWithGoogleTeacher11(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You don't have an account")),
        );
        return;
      }

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('teacher')
              .doc(firebaseUser.uid)
              .get();

          if (!userDoc.exists) {
            String name = googleUser.displayName ?? "";
            String uid = userCredential.user!.uid;

            // Create a model user without saving the email
            ModelTeacher modelUser = ModelTeacher(
              name: name,
              email: "", // Don't store the email yet
              numberId: "", // Placeholder, should be updated later
              id: userCredential.user!.uid,
            );

            // Add teacher to Firestore without email
            await FirebaseFirestore.instance
                .collection('teacher')
                .doc(modelUser.id)
                .set({
              'name': name,
              'numberId': modelUser.numberId,
              // Don't store email here
            });

            // Emit state for user to complete their profile
            emit(GoogleUserNeedsProfileCompletionTeacher());

            // Redirect to CompleteProfileTeacherScreen
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CompleteProfileTeacherScreen(teacherId: modelUser.id),
              ),
            );
          } else {
            // If the user exists, navigate to the HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreenTeacher(
                    modelTeacher: ModelTeacher(
                  id: firebaseUser.uid,
                  name: firebaseUser.displayName ?? "",
                  email: firebaseUser.email ?? "",
                  numberId: userDoc['numberId'] ?? "",
                )),
              ),
            );
          }
        }
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  // Function for registering a new user via Google
  Future<void> registerWithGoogleTeacher(BuildContext context) async {
    emit(RegisterAuthLoading() as AuthStatusTeacher);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(RegisterAuthError(error: "Google login canceled")
            as AuthStatusTeacher);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        // Create the modelUser object
        modelTeacher = ModelTeacher(
          id: userCredential.user?.uid ?? '',
          name: userCredential.user?.displayName ?? '',
          email: userCredential.user?.email ?? '',
          numberId: '',
        );

        // Save user data if needed
        // await FunctionFirebaseUser.saveUserData(modelUser!);

        // Emit state for user to complete their profile
        emit(GoogleUserNeedsProfileCompletion() as AuthStatusTeacher);

        // Redirect to CompleteProfileScreen to fill numberId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CompleteProfileTeacherScreen(teacherId: modelTeacher!.id),
          ),
        );
      } else {
        // Existing user, proceed with normal login
        modelTeacher = ModelTeacher(
          id: userCredential.user?.uid ?? '',
          name: userCredential.user?.displayName ?? '',
          email: userCredential.user?.email ?? '',
          numberId: '', // Fetch numberId from Firestore if necessary
        );
        emit(GoogleUserLoginSuccess() as AuthStatusTeacher);
      }
    } catch (e) {
      emit(RegisterAuthError(
              error: "Google registration failed: ${e.toString()}")
          as AuthStatusTeacher);
    }
  }
}
