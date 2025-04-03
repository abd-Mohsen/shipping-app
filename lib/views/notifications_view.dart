import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/notifications_controller.dart';
import 'package:shipment/views/components/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    NotificationsController nC = Get.find();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'my notifications'.tr.toUpperCase(),
          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<NotificationsController>(
        builder: (controller) {
          return controller.isLoading
              ? SpinKitSquareCircle(color: cs.primary)
              : RefreshIndicator(
                  onRefresh: controller.refreshNotifications,
                  child: controller.allNotifications.isEmpty
                      ? Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Lottie.asset("assets/animations/Notification.json", height: 200),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Center(
                                  child: Text(
                                    "no data, pull down to refresh".tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          itemCount: controller.allNotifications.length,
                          itemBuilder: (context, i) => NotificationCard(
                            notification: controller.allNotifications[i],
                          ),
                        ),
                );
        },
      ),
    );
  }
}
