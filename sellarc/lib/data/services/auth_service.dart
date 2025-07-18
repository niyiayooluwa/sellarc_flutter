import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sellarc/domain/auth_service_interface.dart';
import 'package:sellarc/domain/models/auth_failure.dart';

/// AuthService class provides methods for Firebase authentication.
///
/// This class encapsulates Firebase Authentication and Google Sign-In functionalities,
/// offering methods for signing up, signing in with email/password and Google,
/// signing out, and retrieving the current user.
class AuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Signs up a new user with the given email and password.
  /// Returns an [AuthFailure] if sign-up fails, otherwise returns `null`.
  /// Specific [AuthFailure] types indicate the reason for failure (e.g., weak password, email in use).
  @override
  Future<AuthFailure?> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return AuthFailure.weakPassword();
        case 'email-already-in-use':
          return AuthFailure.emailInUse();
        case 'invalid-email':
          return AuthFailure.invalidEmail();
        case 'network-request-failed':
          return AuthFailure.network();
        default:
          return AuthFailure.unknown();
      }
    } catch (_) {
      return AuthFailure.unknown();
    }
  }

  /// Signs in an existing user with the given email and password.
  /// Returns an [AuthFailure] if sign-in fails, otherwise returns `null`.
  /// Specific [AuthFailure] types indicate the reason for failure (e.g., invalid email, user not found).
  @override
  Future<AuthFailure?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return AuthFailure.invalidEmail();
        case 'user-not-found':
          return AuthFailure.userNotFound();
        case 'wrong-password':
          return AuthFailure.wrongPassword();
        case 'network-request-failed':
          return AuthFailure.network();
        default:
          return AuthFailure.unknown();
      }
    } catch (_) {
      return AuthFailure.unknown();
    }
  }

  /// Signs in a user using their Google account.
  /// Returns an [AuthFailure] if sign-in fails, otherwise returns `null`.
  /// Handles cases like user cancellation, network errors, or other authentication issues.
  @override
  Future<AuthFailure?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthFailure.userCancelled();
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null; // Success
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        return AuthFailure.network();
      }
      return AuthFailure.unknown();
    } catch (_) {
      return AuthFailure.unknown();
    }
  }

  /// Signs out the current user from both Firebase and Google Sign-In.
  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  /// Retrieves the currently authenticated Firebase user.
  /// Returns the [User] object if a user is signed in, otherwise returns null.
  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Stream of auth state changes (null if signed out)
  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

/*
This Dart file defines an `AuthService` class that handles user
authentication using Firebase. It allows users to sign up, sign in with
email/password or Google, sign out, and get the current user.

Let's break down each part:

`import 'package:firebase_auth/firebase_auth.dart';`
  Imports the Firebase Authentication plugin, which provides tools for
  managing user authentication (like creating accounts, signing in, etc.).

`import 'package:google_sign_in/google_sign_in.dart';`
  Imports the Google Sign-In plugin, enabling users to sign in using their
  Google accounts.

`import 'package:sellarc/domain/models/auth_failure.dart';`
  Imports a custom `AuthFailure` class, likely used to represent different authentication error states in a structured way.

`class AuthService { ... }`
  Defines a class named `AuthService`. Classes are blueprints for creating
  objects, and this one will contain all our authentication logic.

`final FirebaseAuth _auth = FirebaseAuth.instance;`
  Creates an instance of `FirebaseAuth`. `FirebaseAuth.instance` is a
  singleton, meaning there's only one instance of it in your app. We use
  `_auth` to interact with Firebase Authentication services. The `_` prefix
  makes `_auth` a private variable, accessible only within this class.

`final GoogleSignIn _googleSignIn = GoogleSignIn();`
  Creates an instance of `GoogleSignIn`. Similar to `FirebaseAuth`, this is
  used to manage the Google Sign-In process.

`Future<AuthFailure?> signUpWithEmail(String email, String password) async { ... }`
  A method to sign up a new user.
  - `Future<AuthFailure?>`: Indicates an asynchronous operation that returns an `AuthFailure` object if an error occurs, or `null` if successful.
  - `email`, `password`: User credentials for signing up.
  `_auth.createUserWithEmailAndPassword(...)` is the Firebase method call.
  - Error handling: Catches `FirebaseAuthException` and maps specific error codes (like 'weak-password', 'email-already-in-use') to custom `AuthFailure` types.

`Future<AuthFailure?> signInWithEmail(String email, String password) async { ... }`
  A method to sign in an existing user with their email and password.
  - Similar to `signUpWithEmail`, it returns `AuthFailure?`.
  `_auth.signInWithEmailAndPassword(...)` is the Firebase method for this.
  - Error handling: Maps Firebase error codes (like 'user-not-found', 'wrong-password') to `AuthFailure` types.

`Future<AuthFailure?> signInWithGoogle() async { ... }`
  A method for users to sign in using their Google account.
  - Returns `AuthFailure?`.
  It first uses `_googleSignIn.signIn()` to initiate the Google login flow.
  If successful, it gets Google authentication tokens and uses them to create
  a Firebase `AuthCredential` with `GoogleAuthProvider.credential(...)`.
  Finally, `_auth.signInWithCredential(credential)` signs the user into Firebase.
  - Error handling: Catches `FirebaseAuthException` (for Firebase-related errors) and `PlatformException` (often for network issues or if the user cancels the Google Sign-In flow).

`Future<void> signOut() async { ... }`
  A method to sign out the current user. It calls `_auth.signOut()` to sign
  out from Firebase and `_googleSignIn.signOut()` to sign out from Google.

`User? getCurrentUser() { ... }`
  A method to get the currently signed-in Firebase user. It returns a `User`
  object if a user is logged in, or `null` otherwise. `_auth.currentUser`
  provides this information.

`Stream<User?> get authStateChanges => _auth.authStateChanges();`
  A getter that provides a stream of `User` objects. This stream emits a new `User` object (or `null`) whenever the user's authentication state changes (e.g., when they sign in or sign out). This is useful for reactively updating the UI based on auth state.

Error Handling (`try...catch`):
  The `try...catch` blocks are used to handle potential errors (like wrong
  password or network issues) that can occur during authentication.
  Instead of rethrowing the original exception, this service maps specific exceptions to instances of `AuthFailure`, providing a more domain-specific error handling mechanism.
*/
