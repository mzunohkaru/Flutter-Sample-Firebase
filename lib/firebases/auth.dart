import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authのサインイン状態のprovider
final signInStateProvider = StateProvider((ref) => 'サインインまたはアカウントを作成してください');

/// サインインユーザーの情報プロバイダー
final userProvider = StateProvider<User?>((ref) => null);

final userEmailProvider = StateProvider<String>((ref) => 'ログインしていません');

final FirebaseAuth auth = FirebaseAuth.instance;

class AuthService {
  /// サインイン処理
  void signIn(WidgetRef ref, String id, String pass) async {
    try {
      /// credential にはアカウント情報が記録される
      final credential = await auth.signInWithEmailAndPassword(
        email: id,
        password: pass,
      );

      /// ユーザ情報の更新
      ref.watch(userProvider.notifier).state =  credential.user;

      /// 画面に表示
      // ref.read(signInStateProvider.notifier).state = 'サインインできました!';
    }

    /// サインインに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      errorHandlerSignIn(ref, e);
    }
  }

  /// サインアップ処理
  void createAccount(WidgetRef ref, String id, String pass) async {
    try {
      /// credential にはアカウント情報が記録される
      final credential = await auth.createUserWithEmailAndPassword(
        email: id,
        password: pass,
      );

      /// ユーザ情報の更新
      ref.watch(userProvider.notifier).state = credential.user;

      /// 画面に表示
      ref.read(signInStateProvider.notifier).state = 'アカウント作成に成功しました!';
    }

    /// アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      errorHandlerSignUp(ref, e);
    } catch (e) {
      print(e);
    }
  }

  /// サインアップ処理 (メールアドレス確認)
  void createAccount_verification(WidgetRef ref, String id, String pass) async {
    try {
      /// credential にはアカウント情報が記録される
      final credential = await auth.createUserWithEmailAndPassword(
        email: id,
        password: pass,
      );

      /// メールアドレスの確認メールを送信
      await credential.user!.sendEmailVerification();
    }

    /// アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      errorHandlerSignUp(ref, e);
    } catch (e) {
      print(e);
    }
  }

  /// メールアドレス確認の判定
  Future<bool> check_verification(WidgetRef ref, String id, String pass) async {
    try {
      // 現在のユーザー情報を取得
      final User? user = auth.currentUser;
      print(user!.email);
      if (user != null && user.emailVerified) {
        // ユーザ情報の更新
        ref.watch(userProvider.notifier).state = user;
        return true;
      }
    }

    /// アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      errorHandlerSignUp(ref, e);
    } catch (e) {
      print(e);
    }
    return false;
  }

  /// パスワードをリセット
  void resetPassword(String id) async {
    try {
      await auth.sendPasswordResetEmail(email: id);
      print("パスワードリセット用のメールを送信しました");
    } catch (e) {
      print(e);
    }
  }

  /// Google認証
  Future googleSingin(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // 認証情報を取得
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        // 認証情報をFirebaseに登録
        User? user = (await auth.signInWithCredential(credential)).user;
        if (user != null) {
          print("Google認証完了");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
  }

  /// エラーハンドラー
  void errorHandlerSignIn(WidgetRef ref, FirebaseAuthException e) {
    /// メールアドレスが無効の場合
    if (e.code == 'invalid-email') {
      ref.read(signInStateProvider.notifier).state = 'メールアドレスが無効です';
    }

    /// ユーザーが存在しない場合
    else if (e.code == 'user-not-found') {
      ref.read(signInStateProvider.notifier).state = 'ユーザーが存在しません';
    }

    /// パスワードが間違っている場合
    else if (e.code == 'wrong-password') {
      ref.read(signInStateProvider.notifier).state = 'パスワードが間違っています';
    }

    /// その他エラー
    else {
      ref.read(signInStateProvider.notifier).state = 'サインインエラー';
    }
  }

  void errorHandlerSignUp(WidgetRef ref, FirebaseAuthException e) {
    /// パスワードが弱い場合
    if (e.code == 'weak-password') {
      ref.read(signInStateProvider.notifier).state = 'パスワードが弱いです';

      /// メールアドレスが既に使用中の場合
    } else if (e.code == 'email-already-in-use') {
      ref.read(signInStateProvider.notifier).state = 'すでに使用されているメールアドレスです';
    }

    /// その他エラー
    else {
      ref.read(signInStateProvider.notifier).state = 'アカウント作成エラー';
    }
  }
}
