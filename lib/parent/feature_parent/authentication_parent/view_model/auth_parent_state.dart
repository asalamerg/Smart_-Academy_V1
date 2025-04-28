
abstract class AuthStatusParent {}

class AuthInitialParent extends AuthStatusParent{}
class AuthChangeUser extends AuthStatusParent{}

class LoginAuthLoadingParent extends AuthStatusParent{}
class LoginAuthErrorParent   extends AuthStatusParent{
  String error ;
  LoginAuthErrorParent({required this.error});

}
class LoginAuthSuccessParent extends AuthStatusParent{}


class RegisterAuthLoadingParent extends AuthStatusParent{}
class RegisterAuthErrorParent   extends AuthStatusParent{
  String error ; RegisterAuthErrorParent({required this.error});
}
class RegisterAuthSuccessParent extends AuthStatusParent{}
