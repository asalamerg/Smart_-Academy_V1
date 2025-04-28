
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/model/model_parent.dart';

class  FunctionFirebaseParent {

  static CollectionReference<ModelParent> getCollectionUser() => FirebaseFirestore.instance.collection("parent")
      .withConverter<ModelParent>(
    fromFirestore: (docSnapShot,_)=>ModelParent.fromJson(docSnapShot.data()!),
    toFirestore:(user,_)=>user.toJson(),
  );

  static Future<ModelParent> registerAccountParent( String email , String name , String numberId , String password ,)async{

    UserCredential  userCredential=  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    ModelParent modelParent=ModelParent(name: name, email: email, numberId: numberId, id: userCredential.user!.uid );

    CollectionReference<ModelParent> getCollection=  getCollectionUser();

    getCollection.doc(modelParent.id).set(modelParent);

    return modelParent;
  }


  static Future<ModelParent> loginAccountParent(String email , String password)async{
    UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password) ;

    CollectionReference<ModelParent> getCollection=  getCollectionUser();
    DocumentSnapshot<ModelParent> documentSnapshot  =await getCollection.doc(userCredential.user!.uid).get();
    return  documentSnapshot.data()!;

  }

  static Future<void> logoutParent()=>FirebaseAuth.instance.signOut();


}