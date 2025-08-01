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

    //NotificationsController nC = Get.find();

    return SafeArea(
      child: Scaffold(
        backgroundColor: cs.surface,
        // appBar: AppBar(
        //   backgroundColor: cs.primary,
        //   title: Text(
        //     'my notifications'.tr.toUpperCase(),
        //     style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        //   ),
        //   centerTitle: true,
        // ),
        body: GetBuilder<NotificationsController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back,
                          color: cs.onSurface,
                          size: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 32, bottom: 16),
                      child: Text(
                        'my notifications'.tr.toUpperCase(),
                        style: tt.headlineSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                if (controller.unreadCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 16),
                    child: Row(
                      children: [
                        Text(
                          "${'you have'.tr} ",
                          style: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                        ),
                        Text(
                          '${controller.unreadCount} ',
                          style: tt.titleSmall!.copyWith(color: cs.primaryContainer),
                        ),
                        Text(
                          "unread notification".tr,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: controller.isLoading && controller.page == 1
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
                                            style: tt.titleMedium!
                                                .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: controller.scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  //padding: const EdgeInsets.symmetric(horizontal: 12),
                                  itemCount: controller.allNotifications.length + 1,
                                  itemBuilder: (context, i) => i < controller.allNotifications.length
                                      ? NotificationCard(
                                          notification: controller.allNotifications[i],
                                          isLast: i == controller.allNotifications.length - 1,
                                          onTap: () {
                                            controller.clickNotification(controller.allNotifications[i]);
                                          },
                                        )
                                      : Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 24),
                                            child: controller.hasMore
                                                ? CircularProgressIndicator(color: cs.primary)
                                                : CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor: cs.onSurface.withValues(alpha: 0.4),
                                                  ),
                                          ),
                                        ),
                                ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
