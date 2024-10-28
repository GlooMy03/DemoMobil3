import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Pesan diterima di background: ${message.notification?.title}');
  // Tambahkan logika tambahan untuk menampilkan notifikasi di sini jika diperlukan
}

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initPushNotification() async {
    // Inisialisasi izin notifikasi
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('Izin yang diberikan pengguna: ${settings.authorizationStatus}');

    // Ambil dan cetak token FCM
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    // Konfigurasi ketika aplikasi dibuka kembali dari kondisi terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Pesan saat aplikasi terminated: ${message.notification?.title}");
        // Tambahkan logika untuk notifikasi ketika aplikasi dibuka
      }
    });

    // Atur handler untuk pesan di background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Inisialisasi local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Tangani pesan yang diterima saat aplikasi di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Pesan diterima di foreground: ${message.notification?.title}");
      // Tampilkan notifikasi di foreground
      _showNotification(message);
    });

    // Tangani pesan yang diterima saat aplikasi dibuka dari terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Pesan dibuka setelah aplikasi diterminasi: ${message.notification?.title}");
      // Tambahkan logika untuk membuka halaman tertentu, jika diperlukan
    });
  }

  // Fungsi untuk menampilkan notifikasi lokal di foreground
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }
}
