// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_sample/firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// /// Authのサインイン状態のprovider
// final signInStateProvider = StateProvider((ref) => 'サインインまたはアカウントを作成してください');

// final userEmailProvider = StateProvider<String>((ref) => 'ログインしていません');

// /// サインインユーザーの情報プロバイダー
// final userProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });

// final FirebaseAuth auth = FirebaseAuth.instance;

// /// UserIDの取得
// final userID = auth.currentUser?.uid ?? '';

// class AuthController {
//   /// サインイン処理
//   void signIn(WidgetRef ref, String id, String pass) async {
//     try {
//       await auth.signInWithEmailAndPassword(
//         email: id,
//         password: pass,
//       );
//     }

//     /// サインインに失敗した場合のエラー処理
//     on FirebaseAuthException catch (e) {
//       errorHandlerSignIn(ref, e);
//     }
//   }

//   /// サインアップ処理
//   void signUp(WidgetRef ref, String id, String pass) async {
//     try {
//       await auth.createUserWithEmailAndPassword(
//         email: id,
//         password: pass,
//       );
//     }

//     /// アカウントに失敗した場合のエラー処理
//     on FirebaseAuthException catch (e) {
//       errorHandlerSignUp(ref, e);
//     } catch (e) {
//       print(e);
//     }
//   }

//   /// サインアップ処理 (メールアドレス確認)
//   void createAccount_verification(WidgetRef ref, String id, String pass) async {
//     try {
//       /// credential にはアカウント情報が記録される
//       final credential = await auth.createUserWithEmailAndPassword(
//         email: id,
//         password: pass,
//       );

//       /// メールアドレスの確認メールを送信
//       await credential.user!.sendEmailVerification();
//     }

//     /// アカウントに失敗した場合のエラー処理
//     on FirebaseAuthException catch (e) {
//       errorHandlerSignUp(ref, e);
//     } catch (e) {
//       print(e);
//     }
//   }

//   /// メールアドレス確認の判定
//   Future<bool> check_verification(WidgetRef ref, String id, String pass) async {
//     try {
//       // 現在のユーザー情報を取得
//       final User? user = auth.currentUser;
//       print(user!.email);
//       if (user.emailVerified) {
//         return true;
//       }
//     }

//     /// アカウントに失敗した場合のエラー処理
//     on FirebaseAuthException catch (e) {
//       errorHandlerSignUp(ref, e);
//     } catch (e) {
//       print(e);
//     }
//     return false;
//   }

//   /// パスワードをリセット
//   void resetPassword(String id) async {
//     try {
//       await auth.sendPasswordResetEmail(email: id);
//       print("パスワードリセット用のメールを送信しました");
//     } catch (e) {
//       print(e);
//     }
//   }

//   /// Google認証
//   Future googleSingin(BuildContext context) async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     final GoogleSignInAccount? googleSignInAccount =
//         await googleSignIn.signIn();

//     if (googleSignInAccount != null) {
//       // 認証情報を取得
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       try {
//         // 認証情報をFirebaseに登録
//         User? user = (await auth.signInWithCredential(credential)).user;
//         if (user != null) {
//           print("Google認証完了");
//         }
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'account-exists-with-different-credential') {
//           // handle the error here
//         } else if (e.code == 'invalid-credential') {
//           // handle the error here
//         }
//       } catch (e) {
//         // handle the error here
//       }
//     }
//   }

//   /// Sign Out
//   Future signOut(WidgetRef ref) async {
//     await FirebaseAuth.instance.signOut();
//   }

//   /// エラーハンドラー
//   void errorHandlerSignIn(WidgetRef ref, FirebaseAuthException e) {
//     /// メールアドレスが無効の場合
//     if (e.code == 'invalid-email') {
//       ref.read(signInStateProvider.notifier).state = 'メールアドレスが無効です';
//     }

//     /// ユーザーが存在しない場合
//     else if (e.code == 'user-not-found') {
//       ref.read(signInStateProvider.notifier).state = 'ユーザーが存在しません';
//     }

//     /// パスワードが間違っている場合
//     else if (e.code == 'wrong-password') {
//       ref.read(signInStateProvider.notifier).state = 'パスワードが間違っています';
//     }

//     /// その他エラー
//     else {
//       ref.read(signInStateProvider.notifier).state = 'サインインエラー';
//     }
//   }

//   void errorHandlerSignUp(WidgetRef ref, FirebaseAuthException e) {
//     /// パスワードが弱い場合
//     if (e.code == 'weak-password') {
//       ref.read(signInStateProvider.notifier).state = 'パスワードが弱いです';

//       /// メールアドレスが既に使用中の場合
//     } else if (e.code == 'email-already-in-use') {
//       ref.read(signInStateProvider.notifier).state = 'すでに使用されているメールアドレスです';
//     }

//     /// その他エラー
//     else {
//       ref.read(signInStateProvider.notifier).state = 'アカウント作成エラー';
//     }
//   }
// }

// void main() async {
//   /// Firebaseの初期化
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const UserCheckPage(),
//     );
//   }
// }

// class UserCheckPage extends ConsumerWidget {
//   const UserCheckPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncValue = ref.watch(userProvider);
//     return Scaffold(
//       body: Center(
//         child: asyncValue.when(
//           data: (user) {
//             return user != null ? const HomePage() : const SignInPage();
//           },
//           loading: () => const CircularProgressIndicator(),
//           error: (_, __) => const SignInPage(),
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Center(
//         child: TextButton(
//           onPressed: () {
//             AuthController().signOut(ref);
//           },
//           child: const Text('SIGN OUT'),
//         ),
//       ),
//     );
//   }
// }

// /// ページ設定
// class SignInPage extends ConsumerStatefulWidget {
//   const SignInPage({Key? key}) : super(key: key);

//   @override
//   SignInPageState createState() => SignInPageState();
// }

// class SignInPageState extends ConsumerState<SignInPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final singInStatus = ref.watch(signInStateProvider);
//     final mailController = TextEditingController();
//     final passController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SignIn Page'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(10),
//         children: <Widget>[
//           /// メールアドレス入力
//           TextField(
//             decoration: const InputDecoration(
//               label: Text('E-mail'),
//               icon: Icon(Icons.mail),
//             ),
//             controller: mailController,
//           ),

//           /// パスワード入力
//           TextField(
//             decoration: const InputDecoration(
//               label: Text('Password'),
//               icon: Icon(Icons.key),
//             ),
//             controller: passController,
//             obscureText: true,
//           ),

//           /// サインイン
//           Container(
//             margin: const EdgeInsets.all(10),
//             child: ElevatedButton(
//               onPressed: () {
//                 /// ログインの場合
//                 AuthController()
//                     .signIn(ref, mailController.text, passController.text);
//               },
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.grey)),
//               child: const Text('サインイン'),
//             ),
//           ),

//           /// アカウント作成
//           Container(
//             margin: const EdgeInsets.all(10),
//             child: ElevatedButton(
//               onPressed: () {
//                 /// アカウント作成の場合
//                 AuthController()
//                     .signUp(ref, mailController.text, passController.text);
//               },
//               child: const Text('アカウント作成'),
//             ),
//           ),

//           /// サインインのメッセージ表示
//           Container(
//             padding: const EdgeInsets.all(10),
//             child: Text('メッセージ : $singInStatus'),
//           ),
//         ],
//       ),
//     );
//   }
// }
