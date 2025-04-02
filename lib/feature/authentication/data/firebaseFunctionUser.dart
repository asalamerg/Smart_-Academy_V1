
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_academy/feature/authentication/data/model_user.dart';

class  FunctionFirebaseUser {

  static CollectionReference<ModelUser> getCollectionUser() => FirebaseFirestore.instance.collection("user")
       .withConverter<ModelUser>(
       fromFirestore: (docSnapShot,_)=>ModelUser.fromJson(docSnapShot.data()!),
       toFirestore:(user,_)=>user.toJson(),
   );

 static Future<ModelUser> RegisterAccount( String email , String name , String numberId , String password ,)async{

   UserCredential  userCredential=  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    ModelUser modelUser=ModelUser(name: name, email: email, numberId: numberId, id: userCredential.user!.uid );

   CollectionReference<ModelUser> getCollection=  getCollectionUser();

    getCollection.doc(modelUser.id).set(modelUser);
    return modelUser;
  }


  static Future<ModelUser> LoginAccount(String email , String password)async{
   UserCredential userCredential= await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password) ;

   CollectionReference<ModelUser> getCollection=  getCollectionUser();
   DocumentSnapshot<ModelUser> documentSnapshot  =await getCollection.doc(userCredential.user!.uid).get();
    return  documentSnapshot.data()!;

  }

  static Future<void> logout()=>FirebaseAuth.instance.signOut();


 }