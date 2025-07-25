import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/views/invoices_view.dart';
import '../../controllers/notifications_controller.dart';
import '../../models/user_model.dart';
import '../notifications_view.dart';
import 'package:badges/badges.dart' as badges;

class UserProfileTile extends StatelessWidget {
  final void Function() onTapProfile;
  final bool isLoadingUser;
  final UserModel? user;
  final bool? company;
  final bool? isPrimaryColor;
  final bool? showBadge;
  final String? locationIndicator;

  const UserProfileTile({
    super.key,
    required this.onTapProfile,
    required this.isLoadingUser,
    required this.user,
    this.company,
    this.isPrimaryColor,
    this.showBadge,
    this.locationIndicator,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    CurrentUserController cUC = Get.find();

    iconWithBorder() => Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              width: 2,
              color: locationIndicator == "tracking" ? Colors.green : Colors.red,
            ),
          ),
          child: locationIndicator == "tracking"
              ? const Icon(Icons.done, color: Colors.green, size: 30)
              : const Icon(Icons.close, color: Colors.red, size: 30),
        );

    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 10),
      decoration: BoxDecoration(
        color: (isPrimaryColor ?? true) ? Color.lerp(cs.primary, Colors.white, 0.025) : cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(-1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onTapProfile,
                    child: badges.Badge(
                      showBadge: showBadge ?? false,
                      position: badges.BadgePosition.topStart(
                        top: 6, // Negative value moves it up
                        start: 6, // Negative value moves it left
                      ),
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: kNotificationColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: (isPrimaryColor ?? true) ? Color.lerp(cs.primary, Colors.white, 0.33) : cs.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(width: 4),
                  isLoadingUser
                      ? SpinKitThreeBounce(color: cs.onPrimary, size: 15)
                      : user == null
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${user!.firstName} ${user!.lastName}",
                                  style: tt.titleSmall!.copyWith(
                                    color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.onSecondaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user!.phoneNumber,
                                  style: tt.labelMedium!.copyWith(
                                    color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            )
                ],
              ),
              Row(
                children: [
                  if (locationIndicator != null)
                    GestureDetector(
                      onTap: () {},
                      child: iconWithBorder(),
                    ),
                  GetBuilder<NotificationsController>(builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      child: badges.Badge(
                        showBadge: controller.unreadCount > 0,
                        position: badges.BadgePosition.topStart(),
                        // smallSize: 10,
                        // backgroundColor: const Color(0xff00ff00),
                        // alignment: Alignment.topRight,
                        // offset: const Offset(-5, -5),
                        badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: kNotificationColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const NotificationsView());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: (isPrimaryColor ?? true) ? Color.lerp(cs.primary, Colors.white, 0.33) : cs.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: GetBuilder<NotificationsController>(
                              builder: (controller) {
                                return Icon(
                                  Icons.notifications_outlined,
                                  color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.onPrimary,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (cUC.currentUser != null) Get.to(InvoicesView(user: cUC.currentUser!));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: (isPrimaryColor ?? true) ? Color.lerp(cs.primary, Colors.black, 0.22) : cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.wallet_outlined, color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.primaryContainer),
                  SizedBox(width: 12),
                  Text(
                    isLoadingUser ? "0.00" : user?.wallet?.balance ?? "0.00",
                    style:
                        tt.titleSmall!.copyWith(color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.primaryContainer),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
