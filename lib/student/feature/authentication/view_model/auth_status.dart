abstract class AuthStatus {}

class AuthInitial extends AuthStatus {}

class LoginAuthLoading extends AuthStatus {}

class LoginAuthSuccess extends AuthStatus {}

class LoginAuthError extends AuthStatus {
  final String error;
  LoginAuthError({required this.error});
}

class RegisterAuthLoading extends AuthStatus {}

class RegisterAuthSuccess extends AuthStatus {}

class RegisterAuthError extends AuthStatus {
  final String error;
  RegisterAuthError({required this.error});
}

class GoogleSignInLoading extends AuthStatus {}

class GoogleSignInSuccess extends AuthStatus {}

class GoogleSignInError extends AuthStatus {
  final String error;
  GoogleSignInError({required this.error});
}

// Add this new status to indicate that Google user needs to complete their profile
class GoogleUserNeedsProfileCompletion extends AuthStatus {}

class GoogleUserLoginSuccess extends AuthStatus {}
