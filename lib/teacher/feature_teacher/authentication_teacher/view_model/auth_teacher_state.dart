
abstract class AuthStatusTeacher {}

class AuthInitialTeacher extends AuthStatusTeacher{}
class AuthChangeUser extends AuthStatusTeacher{}

class LoginAuthLoadingTeacher extends AuthStatusTeacher{}
class LoginAuthErrorTeacher   extends AuthStatusTeacher{
  String error ;
  LoginAuthErrorTeacher({required this.error});

}
class LoginAuthSuccessTeacher extends AuthStatusTeacher{}


class RegisterAuthLoadingTeacher extends AuthStatusTeacher{}
class RegisterAuthErrorTeacher   extends AuthStatusTeacher{
  String error ; RegisterAuthErrorTeacher({required this.error});
}
class RegisterAuthSuccessTeacher extends AuthStatusTeacher{}
