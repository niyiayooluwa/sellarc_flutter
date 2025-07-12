import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.delayed(const Duration(seconds: 2), () {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          context.go('/dashboard');
        } else {
          context.go('/onboarding');
        }
      });
      return null;
    }, []);

    return const Scaffold(
      body: Center(child: FlutterLogo(size: 120)),
    );
  }
}
