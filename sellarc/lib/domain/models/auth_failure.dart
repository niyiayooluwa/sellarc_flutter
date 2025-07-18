sealed class AuthFailure {
  final String message;

  const AuthFailure(this.message);

  factory AuthFailure.weakPassword() =>
      const AuthFailure._('Password is too weak.');

  factory AuthFailure.emailInUse() =>
      const AuthFailure._('Email is already in use.');

  factory AuthFailure.invalidEmail() =>
      const AuthFailure._('Invalid email address.');

  factory AuthFailure.userNotFound() => const AuthFailure._('User not found.');

  factory AuthFailure.wrongPassword() =>
      const AuthFailure._('Incorrect password.');

  factory AuthFailure.userCancelled() =>
      const AuthFailure._('User cancelled the operation.');

  factory AuthFailure.network() => const AuthFailure._('Network error.');

  factory AuthFailure.unknown() =>
      const AuthFailure._('Unknown error occurred.');

  const factory AuthFailure._(String message) = _AuthFailureImpl;
}

class _AuthFailureImpl extends AuthFailure {
  const _AuthFailureImpl(super.message);
}
