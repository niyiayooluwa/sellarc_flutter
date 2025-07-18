import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellarc/data/services/auth_service.dart';

///
/// Riverpod provider to expose the [AuthService] instance.
///
/// This allows the rest of the application to access the authentication
/// service for performing actions like signing in, signing out, etc.
///
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

///
/// Riverpod provider to expose the stream of authentication state changes.
///
/// This allows the application to reactively update the UI based on whether
/// a user is signed in or signed out. It listens to the `authStateChanges`
/// stream from the [AuthService].
///
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

