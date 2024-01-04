import 'package:firebase_sample/repository/firebase_provider.dart';
import 'package:firebase_sample/repository/theme_provider.dart';
import 'package:firebase_sample/views/auth/auth_page.dart';
import 'package:firebase_sample/views/home_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  /// Firebaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  FlexScheme usedScheme = FlexScheme.blueWhale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Counter Firebase',
      themeMode: ref.watch(themeProvider),
      theme: FlexThemeData.light(
        scheme: usedScheme,
        appBarElevation: 0.5,
        useMaterial3: true,
        typography: Typography.material2021(platform: defaultTargetPlatform),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: usedScheme,
        appBarElevation: 2,
        useMaterial3: true,
        typography: Typography.material2021(platform: defaultTargetPlatform),
      ),
      home: const UserCheckPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserCheckPage extends ConsumerWidget {
  const UserCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(userProvider);
    return Scaffold(
      body: Center(
        child: asyncValue.when(
          data: (user) {
            return user != null ? const HomePage() : const AuthPage();
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const AuthPage(),
        ),
      ),
    );
  }
}
