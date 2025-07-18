import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sellarc/providers/auth_providers.dart';
import 'package:sellarc/routing/app_router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
      ),
      builder: (context, child) {
        final auth = ref.watch(authStateChangesProvider);

        return auth.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, __) => const Scaffold(body: Center(child: Text('Auth error'))),
          data: (_) => child!,
        );
      },
      routerConfig: router,
    );
  }
}