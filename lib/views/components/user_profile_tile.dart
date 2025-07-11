import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
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

  const UserProfileTile({
    super.key,
    required this.onTapProfile,
    required this.isLoadingUser,
    required this.user,
    this.company,
    this.isPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    CurrentUserController cUC = Get.find();

    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 10),
      decoration: BoxDecoration(
        color: (isPrimaryColor ?? true) ? Color.lerp(cs.primary, Colors.white, 0.025) : cs.surface,
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
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
              GetBuilder<NotificationsController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  child: badges.Badge(
                    showBadge: controller.unreadCount > 0,
                    position: badges.BadgePosition.topStart(),
                    // smallSize: 10,
                    // backgroundColor: const Color(0xff00ff00),
                    // alignment: Alignment.topRight,
                    // offset: const Offset(-5, -5),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: const Color(0xff00ff00),
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
          GestureDetector(
            onTap: () {
              if (cUC.currentUser != null) Get.to(InvoicesView(user: cUC.currentUser!));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                color: (isPrimaryColor ?? true) ? Color.lerp(cs.primary, Colors.black, 0.22) : cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.wallet_outlined, color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.onPrimary),
                  SizedBox(width: 12),
                  Text(
                    isLoadingUser ? "0.00" : user?.wallet?.balance ?? "0.00",
                    style: tt.titleSmall!.copyWith(color: (isPrimaryColor ?? true) ? cs.onPrimary : cs.onPrimary),
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
