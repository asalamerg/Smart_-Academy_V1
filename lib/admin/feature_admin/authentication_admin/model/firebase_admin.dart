
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/model/model_admin.dart';


class  FunctionFirebaseAdmin {

  static CollectionReference<ModelAdmin> getCollectionAdmin() => FirebaseFirestore.instance.collection("admin")
      .withConverter<ModelAdmin>(
    fromFirestore: (docSnapShot,_)=>ModelAdmin.fromJson(docSnapShot.data()!),
    toFirestore:(user,_)=>user.toJson(),
  );

  static Future<ModelAdmin> registerAccountAdmin( String email , String name , String password ,)async{

    UserCredential  userCredential=  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    ModelAdmin modelAdmin=ModelAdmin(name: name, email: email,  id: userCredential.user!.uid );

    CollectionReference<ModelAdmin> getCollection=  getCollectionAdmin();

    getCollection.doc(modelAdmin.id).set(modelAdmin);
    return modelAdmin;
  }


  static Future<ModelAdmin> loginAccountAdmin(String email , String password)async{
    UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password) ;

    CollectionReference<ModelAdmin> getCollection=  getCollectionAdmin();
    DocumentSnapshot<ModelAdmin> documentSnapshot  =await getCollection.doc(userCredential.user!.uid).get();
    return  documentSnapshot.data()!;

  }

  static Future<void> logoutAdmin()=>FirebaseAuth.instance.signOut();


}