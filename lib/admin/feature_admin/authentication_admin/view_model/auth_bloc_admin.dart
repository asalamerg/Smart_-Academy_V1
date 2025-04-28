
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/model/firebase_admin.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/model/model_admin.dart';
import 'package:smart_academy/admin/feature_admin/authentication_admin/view_model/auth_admin_state.dart';



class AuthBlocAdmin extends Cubit<AuthStatusAdmin>{
  AuthBlocAdmin(): super(AuthInitialAdmin());

  ModelAdmin? modelAdmin ;


  Future<void> loginViewModelAdmin({required String email , required String password})async{
    emit(LoginAuthLoadingAdmin());
    try{
      modelAdmin=  await  FunctionFirebaseAdmin.loginAccountAdmin(email, password);

      emit(LoginAuthSuccessAdmin());

    }catch(e){

      emit(LoginAuthErrorAdmin(error: e.toString()));
    }}

  Future<void> registerViewModelAdmin({required String name , required String password ,required String email })async{
    emit(RegisterAuthLoadingAdmin());
    try{
      modelAdmin= await FunctionFirebaseAdmin.registerAccountAdmin(email, name, password)  ;
      emit(RegisterAuthSuccessAdmin());
    }catch(e){
      emit(RegisterAuthErrorAdmin(error: e.toString()));
    }

  }


}
