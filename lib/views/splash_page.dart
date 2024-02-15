
import 'package:firebase_sample/utils.dart';
import 'package:firebase_sample/views/auth/auth_page.dart';
import 'package:firebase_sample/views/home_page.dart';
import 'package:flutter/material.dart';

/// ログイン状態に応じてユーザーをリダイレクトするページ
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // widgetがmountするのを待つ
    await Future.delayed(Duration.zero);

    /// ログイン状態に応じて適切なページにリダイレクト
    final user = auth.currentUser;
    print("DEBUG: user $user");

    if (user == null) {
      Navigator.of(context)
          .pushAndRemoveUntil(AuthPage.route(), (route) => false);
    } else {
      Navigator.of(context)
          .pushAndRemoveUntil(HomePage.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: preloader
    );
  }
}