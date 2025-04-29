//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:smart_academy/parent/feature_parent/authentication_parent/model/model_parent.dart';
//
// class  FunctionFirebaseParent {
//
//   static CollectionReference<ModelParent> getCollectionUser() => FirebaseFirestore.instance.collection("parent")
//       .withConverter<ModelParent>(
//     fromFirestore: (docSnapShot,_)=>ModelParent.fromJson(docSnapShot.data()!),
//     toFirestore:(user,_)=>user.toJson(),
//   );
//
//   static Future<ModelParent> registerAccountParent( String email , String name , String numberId , String password ,)async{
//
//     UserCredential  userCredential=  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
//     ModelParent modelParent=ModelParent(name: name, email: email, numberId: numberId, id: userCredential.user!.uid );
//
//     CollectionReference<ModelParent> getCollection=  getCollectionUser();
//
//     getCollection.doc(modelParent.id).set(modelParent);
//
//     return modelParent;
//   }
//
//
//   static Future<ModelParent> loginAccountParent(String email , String password)async{
//     UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password) ;
//
//     CollectionReference<ModelParent> getCollection=  getCollectionUser();
//     DocumentSnapshot<ModelParent> documentSnapshot  =await getCollection.doc(userCredential.user!.uid).get();
//     return  documentSnapshot.data()!;
//
//   }
//
//   static Future<void> logoutParent()=>FirebaseAuth.instance.signOut();
//
//
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model_parent.dart';

class FunctionFirebaseParent {
  /// المرجع إلى Collection "parent" باستخدام ModelParent
  static CollectionReference<ModelParent> getCollectionUser() =>
      FirebaseFirestore.instance.collection("parent").withConverter<ModelParent>(
        fromFirestore: (doc, _) => ModelParent.fromJson(doc.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  /// تسجيل حساب جديد لولي الأمر مع التحقق من وجود رقم الطالب مسبقًا
  static Future<ModelParent> registerAccountParent(
      String email,
      String name,
      String numberId,
      String password,
      ) async {
    // تحقق من وجود الطالب أولًا باستخدام رقم الطالب
    QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
        .collection("user")
        .where("numberId", isEqualTo: numberId)
        .get();

    // إذا لم يوجد الطالب، نمنع إنشاء الحساب
    if (studentSnapshot.docs.isEmpty) {
      throw Exception("رقم الطالب غير موجود. الرجاء التأكد من إدخاله بشكل صحيح.");
    }

    // الحصول على UID الخاص بالطالب المرتبط
    String studentUid = studentSnapshot.docs.first.id;

    // إنشاء الحساب في Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // إنشاء نموذج ولي الأمر مع الربط
    ModelParent modelParent = ModelParent(
      id: userCredential.user!.uid,
      name: name,
      email: email,
      numberId: numberId,
      linkedStudentUid: studentUid,
    );

    // تخزين حساب ولي الأمر في Firestore
    await getCollectionUser().doc(modelParent.id).set(modelParent);

    return modelParent;
  }

  /// تسجيل الدخول لحساب ولي الأمر
  static Future<ModelParent> loginAccountParent(String email, String password) async {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    DocumentSnapshot<ModelParent> documentSnapshot =
    await getCollectionUser().doc(userCredential.user!.uid).get();

    return documentSnapshot.data()!;
  }

  /// تسجيل الخروج
  static Future<void> logoutParent() => FirebaseAuth.instance.signOut();
}
