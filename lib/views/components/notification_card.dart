import 'package:flutter/material.dart';
import 'package:shipment/constants.dart';
// import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/notification_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isLast;
  final void Function() onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: cs.surface,
              //   width: 0.5,
              // ),
              borderRadius: BorderRadius.circular(20),
              color: cs.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (notification.isRead) const SizedBox(width: 4),
                if (!notification.isRead)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Color(0xff00ff00),
                    ),
                  ),
                notification.iconUrl != null
                    ? SizedBox(width: 40, height: 40, child: Image.network("$kHostIP${notification.iconUrl!}"))
                    : Icon(
                        Icons.notifications_active,
                        color: cs.primary,
                        size: 35,
                      ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        notification.title,
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Text(
                        notification.content,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: tt.labelMedium!.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
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
                        style: tt.labelMedium!.copyWith(
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
          if (!isLast)
            Divider(
              thickness: 0.8,
              color: cs.onSurface.withOpacity(0.2),
              indent: 12,
            )
        ],
      ),
    );
  }
}
