import 'package:firebase_sample/controllers/auth.dart';
import 'package:firebase_sample/controllers/messaging.dart';
import 'package:firebase_sample/repository/theme_provider.dart';
import 'package:firebase_sample/utils.dart';
import 'package:firebase_sample/views/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const SettingsPage());
  }

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ユーザー情報の取得
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     ref.watch(userEmailProvider.notifier).state = user.email!;
    //   }
    // });

    final theme = ref.watch(themeProvider);

    final themeButton = CupertinoSwitch(
        value: theme == ThemeMode.dark ? true : false,
        onChanged: (_) {
          final notifier = ref.read(themeProvider.notifier);
          notifier.switchTheme(
              theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            leading: const Text("ユーザー"),
            title: Text(auth.currentUser!.email!),
          ),
          ListTile(
            leading: const Text("テーマ"),
            title: themeButton,
          ),
          ListTile(
            leading: const Text("通知"),
            title: TextButton(
                onPressed: () {
                  /// FCMのパーミッション設定
                  FirebaseMessagingService().setting();

                  /// FCMのトークン表示(テスト用)
                  FirebaseMessagingService().fcmGetToken();
                },
                child: const Text("Start FCM")),
          ),
          ElevatedButton(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text("サインアウト"),
            ),
            onPressed: () async {
              await AuthController().signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SplashPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
