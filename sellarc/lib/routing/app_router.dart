import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellarc/providers/auth_providers.dart';

import '../ui/onboarding/onboarding_screen.dart';
import '../ui/splash/screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';

      return authState.when(
        loading: () => null, // Stay put while checking auth state
        error: (_, __) => '/', // Optional: route to splash on error
        data: (user) {
          if (user == null && !isSplash && !isOnboarding) return '/';
          if (user != null && isSplash) return '/onboarding';
          return null;
        },
      );
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      //GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
