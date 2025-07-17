/// This file defines the LocalStorageService class, which manages local data
/// storage using SharedPreferences. It's designed to be a singleton, meaning
/// only one instance of this service will exist throughout the application.
///
/// The `init` method initializes SharedPreferences. It's crucial to call this
/// before using any other methods in the service, typically in the `main`
/// function of your application.
///
/// `isOnboardingCompleted` checks if the 'onboardingCompleted' flag is set in
/// SharedPreferences. It returns `true` if onboarding is complete, and `false`
/// otherwise (or if the flag isn't found).
///
/// `markOnboardingAsCompleted` sets the 'onboardingCompleted' flag to `true`
/// in SharedPreferences, indicating that the user has finished the onboarding
/// process.
///
/// The `localStorageServiceProvider` is a Riverpod provider. It creates and
/// supplies the single instance of LocalStorageService to other parts of the
/// application that need to interact with local storage.
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  late SharedPreferences _prefs;

  // Key for storing the onboarding completion status
  static const _onboardingCompletedKey = 'onboardingCompleted';

  //Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //Method to check if onboarding is completed
  bool isOnboardingCompleted() {
    //Reads a boolean from preferences. If not found, defaults to false
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  //Method to mark onboarding as completed
  Future<void> markOnboardingAsCompleted(bool value) async {
    await _prefs.setBool(_onboardingCompletedKey, value);
  }
}

// Riverpod Provider for LocalStorageService
// We use a simple Provider because LocalStorageService is a single instance
// that provides methods, not reactive state that changes frequently.
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final service = LocalStorageService();
  // Ensure init is called. In a real app, you might await this in main().
  // For now, we'll let main handle the initial init.
  return service;
});