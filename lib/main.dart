import 'package:apartment_manager_user/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/intropage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Khai báo biến toàn cục cho FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Hàm xử lý thông báo trong chế độ nền
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('currentPlatform: ${DefaultFirebaseOptions.currentPlatform}');

  String? token = await FirebaseMessaging.instance.getToken();
  print('Token????????: $token');

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Khởi tạo thông báo
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Đảm bảo biểu tượng đúng

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings); nếu android còn ios thì thêm ios
  if (DefaultFirebaseOptions.currentPlatform == TargetPlatform.android) {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } else {}

  // Đăng ký lắng nghe thông báo
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print('Message data: ${message.notification}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.body}');
      _showNotification(message); // Gọi hàm hiển thị thông báo
    }
  });

  runApp(const MyApp());
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    channelDescription: 'your_channel_description',
    icon: '@mipmap/ic_launcher', // Đảm bảo chỉ định biểu tượng hợp lệ
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
