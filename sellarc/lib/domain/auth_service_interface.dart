
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sellarc/domain/models/auth_failure.dart';

/// Defines the interface for authentication services.
///
/// This abstract class provides a contract that all authentication service
/// implementations (both real and mock) must follow. This allows for
/// easy dependency injection and testing.
abstract class IAuthService {
  /// Stream of authentication state changes.
  /// Emits the current [User] or `null` if signed out.
  Stream<User?> get authStateChanges;

  /// Retrieves the currently authenticated Firebase user.
  User? getCurrentUser();

  /// Signs up a new user with the given email and password.
  Future<AuthFailure?> signUpWithEmail(String email, String password);

  /// Signs in an existing user with the given email and password.
  Future<AuthFailure?> signInWithEmail(String email, String password);

  /// Signs in a user using their Google account.
  Future<AuthFailure?> signInWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();
}
