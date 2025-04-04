import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/models/notification_model.dart';
import '../main.dart';
import '../services/remote_services.dart';
import '../views/redirect_page.dart';

class NotificationsController extends GetxController {
  @override
  onInit() {
    _isLoading = false;
    allNotifications.clear();
    requestPermissionFCM();
    getFCMToken();
    setupFCMListeners();
    getNotifications();
    //_connectNotificationSocket();
    super.onInit();
  }

  @override
  void onClose() {
    //
    super.dispose();
  }

  final GetStorage _getStorage = GetStorage();

  int notificationID = 0;

  bool newNotifications = true;

  void _connectNotificationSocket() async {
    String socketUrl = 'wss://shipping.adadevs.com/ws/notifications/';

    final websocket = await WebSocket.connect(
      socketUrl,
      protocols: ['Token', _getStorage.read("token")],
    );

    websocket.listen(
      (message) {
        print('Message from server: $message');
        message = jsonDecode(message);
        notificationService.showNotification(
          id: notificationID,
          title: message["type"] + notificationID.toString(),
          body: message["text"],
        );
        notificationID++;
      },
      onDone: () {
        print('WebSocket connection closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
    );
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestPermissionFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
  }

  Future<String?> getFCMToken() async {
    String? deviceToken = await _firebaseMessaging.getToken();
    print('FCM Token: $deviceToken');
    if (deviceToken != null) {
      await RemoteServices.subscribeFCM(deviceToken); //todo: not working
      //todo: try registering another user from same device
    }
    return deviceToken;
  }

  void setupFCMListeners() {
    //todo: notification from here and websocket are appearing together when listening here
    //todo: notifications from here appears without badge when app is close
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Received notification: ${message.notification?.title}');
      // print('Body: ${message.notification?.body}');
      notificationService.showNotification(
        id: notificationID,
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.notification?.title}');
      Get.offAll(() => const RedirectPage());
    });
  }

  //-------------------------notifications page--------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<NotificationModel> allNotifications = [];

  void getNotifications() async {
    toggleLoading(true);
    //todo with pagination
    //todo refresh when new notification
    // currOrders.clear();
    // List<MiniOrderModel> newItems = await RemoteServices.fetchDriverCurrOrders() ?? [];
    // currOrders.addAll(newItems);
    toggleLoading(false);
  }

  Future<void> refreshNotifications() async {
    allNotifications.clear();
    getNotifications();
  }
}
