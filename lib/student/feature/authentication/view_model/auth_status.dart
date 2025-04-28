
abstract class AuthStatus {}

class AuthInitial extends AuthStatus{}
class AuthChangeUser extends AuthStatus{}

class LoginAuthLoading extends AuthStatus{}
class LoginAuthError   extends AuthStatus{
  String error ;
  LoginAuthError({required this.error});

}
class LoginAuthSuccess extends AuthStatus{}


class RegisterAuthLoading extends AuthStatus{}
class RegisterAuthError   extends AuthStatus{
  String error ; RegisterAuthError({required this.error});
}
class RegisterAuthSuccess extends AuthStatus{}
