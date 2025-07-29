import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import '../../constants.dart';
import '../notifications_view.dart';

class NotificationButton extends StatelessWidget {
  final bool showBadge;
  final Color color;
  const NotificationButton({
    super.key,
    required this.showBadge,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    //ColorScheme cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: badges.Badge(
        showBadge: showBadge,
        position: badges.BadgePosition.topStart(
          top: -2, // Negative value moves it up
          start: -4, // Negative value moves it left
        ),
        badgeStyle: badges.BadgeStyle(
          shape: badges.BadgeShape.circle,
          badgeColor: kNotificationColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: GestureDetector(
          onTap: () {
            Get.to(() => const NotificationsView());
          },
          child: Icon(
            Icons.notifications,
            color: color,
            //size: 30,
          ),
        ),
      ),
    );
  }
}
