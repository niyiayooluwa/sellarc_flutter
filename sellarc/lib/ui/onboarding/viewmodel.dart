import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sellarc/data/services/local_storage_service.dart';

/// The ViewModel for the Onboarding screen.
///
/// This class encapsulates the business logic related to the onboarding process,
/// separating it from the UI code.
class OnboardingViewModel {
  final LocalStorageService _localStorageService;

  OnboardingViewModel(this._localStorageService);

  /// Marks the onboarding process as completed in local storage.
  Future<void> completeOnboarding() async {
    await _localStorageService.markOnboardingAsCompleted(true);
  }
}

/// Riverpod provider for the [OnboardingViewModel].
///
/// This provider creates an instance of the ViewModel and injects its
/// dependency ([LocalStorageService]), making it available to the UI.
final onboardingViewModelProvider = Provider<OnboardingViewModel>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return OnboardingViewModel(localStorageService);
});