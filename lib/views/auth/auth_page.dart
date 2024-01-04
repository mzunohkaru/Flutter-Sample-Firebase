import 'package:firebase_sample/controllers/auth.dart';
import 'package:firebase_sample/repository/firebase_provider.dart';
import 'package:firebase_sample/utils.dart';
import 'package:firebase_sample/views/auth/check_email_page.dart';
import 'package:firebase_sample/widgets/google_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends ConsumerState<AuthPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final singInStatus = ref.watch(signInStateProvider);
    final emailController = TextEditingController();
    final passController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Auth Page'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          /// サインインのメッセージ表示
          Container(
            padding: const EdgeInsets.all(10),
            child: Text('メッセージ : $singInStatus'),
          ),

          const SizedBox(
            height: 30,
          ),

          /// メールアドレス入力
          TextField(
            decoration: const InputDecoration(
              label: Text('E-mail'),
              icon: Icon(Icons.mail),
            ),
            controller: emailController,
          ),

          /// パスワード入力
          TextField(
            decoration: const InputDecoration(
              label: Text('Password'),
              icon: Icon(Icons.key),
            ),
            controller: passController,
            obscureText: true,
          ),

          const SizedBox(
            height: 30,
          ),

          /// サインイン
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                AuthController().signIn(
                    ref: ref,
                    email: emailController.text,
                    pass: passController.text);
              },
              child: const Text('サインイン'),
            ),
          ),

          /// サインアップ
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                if (emailController.text.isEmpty ||
                    passController.text.isEmpty) {
                  return;
                }
                AuthController()
                    .signUp(ref, emailController.text, passController.text);
              },
              child: const Text('サインアップ'),
            ),
          ),

          /// サインアップ (メールアドレスの確認)
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckEmailPage(
                            email: emailController.text,
                            pass: passController.text,
                          )),
                );
              },
              child: const Text('サインアップ (メールアドレスの確認)'),
            ),
          ),

          // パスワードリセット
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                AuthController().resetPassword(emailController.text);
              },
              child: const Text('パスワードリセット'),
            ),
          ),

          // Google認証
          Container(
            margin: const EdgeInsets.all(10),
            child: const GoogleSignInButton(),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                AuthController().signOut();
              },
              child: const Text('サインアウト'),
            ),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                print(userID);
                print(ref.read(userProvider));
              },
              child: const Text('Check'),
            ),
          ),
        ],
      ),
    );
  }
}
