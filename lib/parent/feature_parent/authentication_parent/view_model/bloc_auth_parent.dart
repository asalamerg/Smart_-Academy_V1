
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/model/firebase_parent.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/model/model_parent.dart';
import 'package:smart_academy/parent/feature_parent/authentication_parent/view_model/auth_parent_state.dart';



class AuthBlocParent extends Cubit<AuthStatusParent>{
  AuthBlocParent(): super(AuthInitialParent());

  ModelParent? modelParent ;



  Future<void> loginViewModelParent({required String email, required String password, required String studentId}) async {
    emit(LoginAuthLoadingParent());
    try {
      modelParent = await FunctionFirebaseParent.loginAccountParent(email, password, studentId);
      emit(LoginAuthSuccessParent());
    } catch (e) {
      emit(LoginAuthErrorParent(error: e.toString()));
    }
  }

  Future<void> registerViewModelParent({required String name , required String password , required String numberId ,required String email })async{
    emit(RegisterAuthLoadingParent());
    try{
      modelParent=  await FunctionFirebaseParent.registerAccountParent(email, name, numberId, password);
      emit(RegisterAuthSuccessParent());
    }catch(e){
      emit(RegisterAuthErrorParent(error: e.toString()));
    }

  }


}
