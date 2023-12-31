import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sample/firebases/auth.dart';
import 'package:firebase_sample/main.dart';
import 'package:firebase_sample/repository/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ユーザー情報の取得
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        ref.watch(userEmailProvider.notifier).state = user.email!;
      }
    });

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
            title: Text(
              ref.watch(userEmailProvider),
            ),
          ),
          ListTile(
            leading: const Text("テーマ"),
            title: themeButton,
          ),
          ElevatedButton(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Text("サインアウト"),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              ref.watch(userProvider.notifier).state = await null;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
