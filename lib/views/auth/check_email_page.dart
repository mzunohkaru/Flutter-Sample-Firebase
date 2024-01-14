import 'package:firebase_sample/controllers/auth.dart';
import 'package:firebase_sample/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String pass;

  const CheckEmailPage({required this.email, required this.pass});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Auth Page'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          /// メールアドレス入力
          TextField(
            decoration: const InputDecoration(
              label: Text('E-mail'),
              icon: Icon(Icons.mail),
            ),
            controller: TextEditingController(text: widget.email),
            enabled: false,
          ),

          /// パスワード入力
          TextField(
            decoration: const InputDecoration(
              label: Text('Password'),
              icon: Icon(Icons.key),
            ),
            controller: TextEditingController(text: widget.pass),
            enabled: false,
            obscureText: false,
          ),

          const SizedBox(
            height: 30,
          ),

          /// サインアップ
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                AuthController().createAccount_verification(
                    email: widget.email, pass: widget.pass);
              },
              child: const Text('確認メールの送信'),
            ),
          ),

          /// メールアドレスの確認の判定
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                if (AuthController().check_verification() == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }
              },
              child: const Text("メールアドレスの確認を完了"),
            ),
          ),
        ],
      ),
    );
  }
}
