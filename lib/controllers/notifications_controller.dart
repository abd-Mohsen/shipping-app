import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/models/notification_model.dart';
import 'package:shipment/views/notifications_view.dart';
import 'package:shipment/views/order_view.dart';
import '../main.dart';
import '../services/remote_services.dart';
import '../views/redirect_page.dart';

//todo: i once got: notification controller was called after being disposed, how was it disposed?

class NotificationsController extends GetxController {
  @override
  onInit() {
    requestPermissionFCM();
    getFCMToken();
    setupFCMListeners();
    getNotifications();
    setPaginationListener();
    super.onInit();
  }

  @override
  void onClose() {
    super.dispose();
  }

  final GetStorage _getStorage = GetStorage();

  int notificationID = 0;

  bool newNotifications = true;

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
      await RemoteServices.subscribeFCM(deviceToken);
    }
    return deviceToken;
  }

  void setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await refreshNotifications();
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
      Get.offAll(() => const RedirectPage(toNotifications: true));
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
  int unreadCount = 0;

  ScrollController scrollController = ScrollController();

  int page = 1, limit = 10;
  bool hasMore = true;

  //bool failed = false;

  void setPaginationListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        getNotifications();
      }
    });
  }

  void getNotifications() async {
    hasMore = true;
    if (isLoading) return;
    toggleLoading(true);
    Map<String, dynamic>? newItems = await RemoteServices.fetchNotifications(page: page);
    if (newItems != null) {
      if (newItems["notifications"].length < limit) hasMore = false;
      allNotifications.addAll(newItems["notifications"]);
      unreadCount = newItems["unread_count"];
      page++;
    } else {
      hasMore = false;
    }
    toggleLoading(false);
  }

  Future<void> refreshNotifications() async {
    page = 1;
    hasMore = true;
    allNotifications.clear();
    getNotifications();
  }

  void clickNotification(NotificationModel notification) {
    readNotification(notification);
    if (notification.action == "go_to_order") {
      Get.to(OrderView(orderID: notification.actionParams!.orderId!));
    }
  }

  void readNotification(NotificationModel notification) async {
    if (notification.isRead) return;
    bool success = await RemoteServices.readNotification(notification.id);
    if (success) {
      notification.markAsRead();
      unreadCount--;
      update();
    }
  }
}
