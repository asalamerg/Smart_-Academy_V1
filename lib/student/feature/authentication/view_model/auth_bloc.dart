import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_academy/student/feature/authentication/model/firebaseFunctionUser.dart';
import 'package:smart_academy/student/feature/authentication/model/model_user.dart';
import 'package:smart_academy/student/feature/authentication/view_model/auth_status.dart';

class AuthBloc extends Cubit<AuthStatus> {
  AuthBloc() : super(AuthInitial());

  ModelUser? modelUser;

  Future<void> loginViewModel(
      {required String email, required String password}) async {
    emit(LoginAuthLoading());
    try {
      modelUser = await FunctionFirebaseUser.loginAccount(email, password);

      emit(LoginAuthSuccess());
    } catch (e) {
      emit(LoginAuthError(error: e.toString()));
    }
  }

  Future<void> registerViewModel(
      {required String name,
      required String password,
      required String numberId,
      required String email}) async {
    emit(RegisterAuthLoading());
    try {
      modelUser = await FunctionFirebaseUser.registerAccount(
          email, name, numberId, password);
      emit(RegisterAuthSuccess());
    } catch (e) {
      emit(RegisterAuthError(error: e.toString()));
    }
  }
}
