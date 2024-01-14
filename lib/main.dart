import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_sample/repository/theme_provider.dart';
import 'package:firebase_sample/views/splash_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// プラットフォームの確認
final isAndroid =
    defaultTargetPlatform == TargetPlatform.android ? true : false;
final isIOS = defaultTargetPlatform == TargetPlatform.iOS ? true : false;

/// FCMバックグランドメッセージの設定
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future main() async {
  /// Firebaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// FCMのバックグランドメッセージを表示
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}