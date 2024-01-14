import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_sample/main.dart';

/// Firebase Cloud Messageの設定
class FirebaseMessagingService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// webとiOS向け設定
  void setting() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void fcmGetToken() async {
    /// モバイル向け
    if (isAndroid || isIOS) {
      final fcmToken = await messaging.getToken();
      print(fcmToken);
    }
  }
}