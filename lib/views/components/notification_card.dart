import 'package:flutter/material.dart';
// import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        //Get.to(() => OrderView(order: notification, isCustomer: isCustomer));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 3,
          color: cs.surface,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: cs.onSurface,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Icon(
                  Icons.notifications_active,
                  color: cs.primary,
                  size: 35,
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        notification.title,
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Text(
                        notification.content,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall!.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width / 2.5,
                    //   child: Text(
                    //     " ${Jiffy.parseFromDateTime(notification.timestamp).format(pattern: "d / M / y")}"
                    //     "  ${Jiffy.parseFromDateTime(notification.timestamp).jm}",
                    //     style: tt.titleSmall!.copyWith(
                    //       color: cs.onSurface.withOpacity(0.8),
                    //     ),
                    //     overflow: TextOverflow.ellipsis,
                    //     maxLines: 1,
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Text(
                        timeago.format(notification.timestamp, locale: 'en_short'),
                        style: tt.titleSmall!.copyWith(
                          color: cs.onSurface.withOpacity(0.8),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
