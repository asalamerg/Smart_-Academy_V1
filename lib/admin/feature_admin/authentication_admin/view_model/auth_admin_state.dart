
abstract class AuthStatusAdmin {}

class AuthInitialAdmin extends AuthStatusAdmin{}
class AuthChangeAdmin extends AuthStatusAdmin{}

class LoginAuthLoadingAdmin extends AuthStatusAdmin{}
class LoginAuthErrorAdmin   extends AuthStatusAdmin{
  String error ;
  LoginAuthErrorAdmin({required this.error});

}
class LoginAuthSuccessAdmin extends AuthStatusAdmin{}


class RegisterAuthLoadingAdmin extends AuthStatusAdmin{}
class RegisterAuthErrorAdmin   extends AuthStatusAdmin{
  String error ; RegisterAuthErrorAdmin({required this.error});
}
class RegisterAuthSuccessAdmin extends AuthStatusAdmin{}
