/// The `OnboardingScreen` widget displays a multi-page onboarding flow using a [PageView].
///
/// - Utilizes Flutter Hooks (`usePageController`, `useState`) for state management.
/// - Integrates with Riverpod via [HookConsumerWidget] and [WidgetRef].
/// - Shows three onboarding pages with custom content and images.
/// - Includes a smooth page indicator at the bottom.
/// - Provides "Skip"/"Done" and "Next" buttons for navigation:
///   - "Skip" or "Done" completes onboarding and navigates to the authentication route.
///   - "Next" advances to the next onboarding page.
/// - The [OnboardingPage] widget is used to render each page's content.
/// - Includes a [ColorExtension] to darken colors for text styling.
///
/// Dependencies:
/// - `flutter_hooks` for hooks-based state management.
/// - `hooks_riverpod` for dependency injection and state.
/// - `go_router` for navigation.
/// - `smooth_page_indicator` for animated page indicators.
///
/// Usage:
/// ```dart
/// OnboardingScreen()
/// ```
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import Flutter Hooks
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import Riverpod hooks
import 'package:go_router/go_router.dart';
import 'package:sellarc/ui/onboarding/viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Use HookConsumerWidget for widgets that need hooks and Riverpod
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef for Riverpod access
    final pageController = usePageController(); // Use hook for PageController
    final isLastPage = useState(
      false,
    ); // Use hook for local state (replaces setState)

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              isLastPage.value = (index == 2); // Update the state hook's value
            },
            children: const [
              OnboardingPage(
                color: Colors.blue,
                title: 'Welcome to Sellarc',
                description: 'Your ultimate sales and inventory manager.',
                imagePath: 'assets/images/onboarding_welcome.png',
              ),
              OnboardingPage(
                color: Colors.green,
                title: 'Effortless Product Management',
                description: 'Keep track of all your inventory with ease.',
                imagePath: 'assets/images/onboarding_products.png',
              ),
              OnboardingPage(
                color: Colors.purple,
                title: 'Track Your Sales & Grow',
                description:
                    'Log sales, generate reports, and see your business thrive.',
                imagePath: 'assets/images/onboarding_sales.png',
              ),
            ],
          ),

          // Page Indicator
          Align(
            alignment: const Alignment(0, 0.8),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 3,
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.deepPurple,
                dotColor: Colors.grey,
              ),
            ),
          ),

          // 💻 F01.3-SKIP: Add skip functionality and smooth animations
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0, right: 20.0),
              child: TextButton(
                onPressed: () async {
                  await ref
                      .read(onboardingViewModelProvider)
                      .completeOnboarding();
                  context.go('/auth');
                }, // Call our function
                child: Text(
                  isLastPage.value ? 'Done' : 'Skip', // Read state hook's value
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ),

          // Next button (if not on last page)
          if (!isLastPage.value) // Read state hook's value
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 20.0),
                child: TextButton(
                  onPressed: () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// OnboardingPage remains the same as it's stateless
class OnboardingPage extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final String? imagePath;

  const OnboardingPage({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(
              imagePath!,
              height: 200,
              width: 200,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: 150,
                  color: color.withOpacity(0.5),
                );
              },
            )
          else
            Icon(Icons.info_outline, size: 150, color: color.withAlpha((255 * 0.5).round())),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color.darken(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: color.darken(0.3)),
          ),
        ],
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
