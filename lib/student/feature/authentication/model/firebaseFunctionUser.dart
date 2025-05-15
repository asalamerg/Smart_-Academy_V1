import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_academy/student/feature/authentication/model/model_user.dart';

class FunctionFirebaseUser {
  // إرجاع مجموعة المستخدمين مع المحول بين Firestore و ModelUser
  static CollectionReference<ModelUser> getCollectionUser() =>
      FirebaseFirestore.instance.collection("user").withConverter<ModelUser>(
            fromFirestore: (docSnapShot, _) =>
                ModelUser.fromJson(docSnapShot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  // دالة لتسجيل المستخدم
  static Future<ModelUser> registerAccount(
      String email, String name, String numberId, String password) async {
    try {
      // إنشاء حساب باستخدام Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // إنشاء نموذج المستخدم
      ModelUser modelUser = ModelUser(
          name: name,
          email: email,
          numberId: numberId,
          id: userCredential.user!.uid,
          courses: []);

      // إضافة المستخدم إلى Firestore
      CollectionReference<ModelUser> getCollection = getCollectionUser();
      await getCollection.doc(modelUser.id).set(modelUser);

      // إرجاع نموذج المستخدم
      return modelUser;
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  // دالة لتسجيل الدخول
  static Future<ModelUser> loginAccount(String email, String password) async {
    try {
      // تسجيل الدخول باستخدام Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // الحصول على بيانات المستخدم من Firestore
      CollectionReference<ModelUser> getCollection = getCollectionUser();
      DocumentSnapshot<ModelUser> documentSnapshot =
          await getCollection.doc(userCredential.user!.uid).get();

      // إرجاع بيانات المستخدم
      return documentSnapshot.data()!;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // دالة لتسجيل الخروج
  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }
}
