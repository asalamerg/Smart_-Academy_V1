
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';


class  FunctionFirebaseTeacher {

  static CollectionReference<ModelTeacher> getCollectionUser() => FirebaseFirestore.instance.collection("teacher")
      .withConverter<ModelTeacher>(
    fromFirestore: (docSnapShot,_)=>ModelTeacher.fromJson(docSnapShot.data()!),
    toFirestore:(user,_)=>user.toJson(),
  );

  static Future<ModelTeacher> registerAccountTeacher( String email , String name , String numberId , String password ,)async{

    UserCredential  userCredential=  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    ModelTeacher modelUser=ModelTeacher(name: name, email: email, numberId: numberId, id: userCredential.user!.uid );

    CollectionReference<ModelTeacher> getCollection=  getCollectionUser();

    getCollection.doc(modelUser.id).set(modelUser);
    return modelUser;
  }


  static Future<ModelTeacher> loginAccountTeacher(String email , String password)async{
    UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password) ;

    CollectionReference<ModelTeacher> getCollection=  getCollectionUser();
    DocumentSnapshot<ModelTeacher> documentSnapshot  =await getCollection.doc(userCredential.user!.uid).get();
    return  documentSnapshot.data()!;

  }

  static Future<void> logoutTeacher()=>FirebaseAuth.instance.signOut();


}