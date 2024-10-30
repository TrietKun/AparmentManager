import 'package:apartment_manager_user/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/intropage.dart';

// Hàm xử lý thông báo trong chế độ nền
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Xử lý thông báo khi ứng dụng ở chế độ nền
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Yêu cầu quyền nhận thông báo (chỉ trên iOS)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Lắng nghe thông báo khi ứng dụng đang chạy
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message while in foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  // Lắng nghe thông báo khi ứng dụng ở chế độ nền
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Lắng nghe thông báo khi ứng dụng đang chạy
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print('Message data: ${message.data}');
  });

  // Lấy FCM Token
  try {
    var token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');
  } catch (e) {
    print('Error getting FCM token: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Intro(),
    );
  }
}
