import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/notification_model.dart';

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
                  Icons.local_shipping,
                  color: cs.primary,
                  size: 35,
                ),
                const SizedBox(width: 24),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width / 2,
                //       child: Text(
                //         notification.description,
                //         style: tt.titleMedium!.copyWith(color: cs.onSurface),
                //         overflow: TextOverflow.ellipsis,
                //         maxLines: 2,
                //       ),
                //     ),
                //     const SizedBox(height: 12),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width / 1.6,
                //       child: Text(
                //         "${notification.startPoint.name} - ${notification.endPoint.name}",
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //         style: tt.titleSmall!.copyWith(
                //           color: cs.onSurface.withOpacity(0.5),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(height: 8),
                //     Row(
                //       children: [
                //         SizedBox(
                //           width: MediaQuery.of(context).size.width / 2.5,
                //           child: Text(
                //             " ${Jiffy.parseFromDateTime(notification.dateTime).format(pattern: "d / M / y")}"
                //                 "  ${Jiffy.parseFromDateTime(notification.dateTime).jm}",
                //             style: tt.titleSmall!.copyWith(
                //               color:
                //               notification.dateTime.isBefore(DateTime.now()) && !["draft", "done"].contains(notification.status)
                //                   ? cs.error
                //                   : cs.onSurface.withOpacity(0.8),
                //             ),
                //             overflow: TextOverflow.ellipsis,
                //             maxLines: 1,
                //           ),
                //         ),
                //         const SizedBox(width: 4),
                //         Visibility(
                //           visible: notification.dateTime.isBefore(DateTime.now()) && !["draft", "done"].contains(notification.status),
                //           child: GestureDetector(
                //             onTap: () {
                //               showPopover(
                //                 context: context,
                //                 backgroundColor: cs.surface,
                //                 bodyBuilder: (context) => Padding(
                //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                //                   child: Text(
                //                     "order was not accepted in time".tr,
                //                     style: tt.titleMedium!.copyWith(color: cs.onSurface),
                //                     overflow: TextOverflow.ellipsis,
                //                     maxLines: 2,
                //                   ),
                //                 ),
                //               );
                //             },
                //             child: Icon(Icons.info, color: cs.error, size: 20),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // if (notification.status == "pending" && isCustomer)
                //   Icon(
                //     Icons.access_time_rounded,
                //     color: cs.onSurface,
                //     size: 25,
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
