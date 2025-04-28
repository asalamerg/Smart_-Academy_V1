
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/firebase_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/model/model_teacher.dart';
import 'package:smart_academy/teacher/feature_teacher/authentication_teacher/view_model/auth_teacher_state.dart';


class AuthBlocTeacher extends Cubit<AuthStatusTeacher>{
  AuthBlocTeacher(): super(AuthInitialTeacher());

ModelTeacher? modelTeacher ;


  Future<void> loginViewModelTeacher({required String email , required String password})async{
    emit(LoginAuthLoadingTeacher());
    try{
      modelTeacher=  await  FunctionFirebaseTeacher.loginAccountTeacher(email, password);

      emit(LoginAuthSuccessTeacher());

    }catch(e){

      emit(LoginAuthErrorTeacher(error: e.toString()));
    }}

  Future<void> registerViewModelTeacher({required String name , required String password , required String numberId ,required String email })async{
    emit(RegisterAuthLoadingTeacher());
    try{
      modelTeacher=  await FunctionFirebaseTeacher.registerAccountTeacher(email, name, numberId, password);
      emit(RegisterAuthSuccessTeacher());
    }catch(e){
      emit(RegisterAuthErrorTeacher(error: e.toString()));
    }

  }


}
