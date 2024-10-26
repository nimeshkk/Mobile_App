import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  void initialize() async {
    try {
      // Fetch and print the token
      String? token = await messaging.getToken();
      if (token != null) {
        print("FCM Token: $token");
      } else {
        print("Failed to retrieve FCM token.");
      }
    } catch (e) {
      print("Error retrieving FCM token: $e");
    }
  }
}
