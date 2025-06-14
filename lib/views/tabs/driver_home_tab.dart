import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/views/components/curr_order_card.dart';
import 'package:shipment/views/components/titled_card.dart';
import 'package:shipment/views/my_vehicles_view.dart';
import '../../controllers/notifications_controller.dart';
import '../components/order_card_2.dart';
import 'package:badges/badges.dart' as badges;

import '../components/selection_circle.dart';
import '../components/titled_scrolling_card.dart';
import '../notifications_view.dart';

class DriverHomeTab extends StatelessWidget {
  const DriverHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<DriverHomeController>(
      //init: HomeController(),
      builder: (controller) {
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 15,
                  child: Container(
                    color: cs.primary,
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: Container(
                    color: cs.surface,
                  ),
                ),
              ],
            ),
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.scaffoldKey.currentState?.openDrawer();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  child: badges.Badge(
                                    showBadge: controller.currentUser != null &&
                                        controller.currentUser!.role.type == "driver" &&
                                        ["refused", "No_Input"]
                                            .contains(controller.currentUser!.driverInfo?.vehicleStatus),
                                    position: badges.BadgePosition.topStart(
                                      top: -2, // Negative value moves it up
                                      start: -4, // Negative value moves it left
                                    ),
                                    badgeStyle: badges.BadgeStyle(
                                      shape: badges.BadgeShape.circle,
                                      badgeColor: kNotificationColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Color.lerp(cs.primary, Colors.white, 0.33),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(Icons.person_outline, color: cs.onPrimary),
                                    ),
                                  ),
                                ),
                              ),
                              //SizedBox(width: 4),
                              controller.isLoadingUser
                                  ? SpinKitThreeBounce(color: cs.onPrimary, size: 15)
                                  : controller.currentUser == null
                                      ? const SizedBox.shrink()
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${controller.currentUser!.firstName} ${controller.currentUser!.lastName}",
                                              style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              controller.currentUser!.phoneNumber,
                                              style: tt.labelMedium!.copyWith(color: cs.onPrimary.withOpacity(0.8)),
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
                                  child: GetBuilder<NotificationsController>(
                                    builder: (controller) {
                                      return Icon(
                                        Icons.notifications,
                                        color: cs.onPrimary,
                                        //size: 30,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
                  child: Text(
                    "Tracking status".tr,
                    style: tt.titleSmall!.copyWith(color: cs.onPrimary, fontWeight: FontWeight.normal),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
                  child: GestureDetector(
                    onTap: () {
                      controller.reconnectTracking();
                    },
                    child: Card(
                      color: Color.lerp(cs.primary, Colors.white, 0.33),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     controller.refreshMap();
                            //   },
                            //   child: CircleAvatar(
                            //     backgroundColor: cs.primary,
                            //     foregroundColor: cs.onPrimary,
                            //     child: Icon(Icons.refresh),
                            //     radius: 20,
                            //   ),
                            // ),
                            Icon(
                              Icons.location_on_outlined,
                              color: controller.trackingStatus == "tracking" ? const Color(0xff00ff00) : cs.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              //width: MediaQuery.of(context).size.width / 1.2,
                              child: Text(
                                controller.trackingStatus.tr,
                                style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //
                Visibility(
                  visible: controller.currentUser != null &&
                      controller.currentUser!.role.type == "driver" &&
                      ["refused", "No_Input"].contains(controller.currentUser!.driverInfo?.vehicleStatus),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const MyVehiclesView(openSheet: true));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF5E5C4),
                            Color(0xFFF1C68B),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 1],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.warning_amber,
                                color: Color(0xFF92833C),
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "you dont have a vehicle".tr,
                                    style: tt.titleSmall!
                                        .copyWith(color: const Color(0xFF92833C), fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "click here to go to vehicles page".tr,
                                    style: tt.labelMedium!.copyWith(color: const Color(0xFF92833C)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Icon(
                            Icons.add,
                            color: Color(0xFF92833C),
                            size: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //
                Container(
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    color: cs.surface,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                        child: TitledCard(
                          title: "orders status".tr,
                          radius: 20,
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SelectionCircle(
                                iconData: Icons.watch_later_outlined,
                                title: "taken".tr,
                                isSelected: false,
                                onTap: () {
                                  controller.setOrderType("taken", true);
                                },
                              ),
                              SelectionCircle(
                                iconData: Icons.task_alt,
                                title: "accepted".tr,
                                isSelected: false,
                                onTap: () {
                                  controller.setOrderType("accepted", true);
                                },
                              ),
                              SelectionCircle(
                                iconData: Icons.local_shipping_outlined,
                                title: "current".tr,
                                isSelected: false,
                                onTap: () {
                                  controller.setOrderType("current", true);
                                },
                              ),
                              SelectionCircle(
                                iconData: Icons.done_all,
                                title: "finished".tr,
                                isSelected: false,
                                onTap: () {
                                  controller.setOrderType("finished", true);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: controller.isLoadingRecent
                            ? SpinKitThreeBounce(color: cs.surface, size: 20)
                            : CurrOrderCard(
                                order: controller.currentOrder,
                                borderRadius: BorderRadius.circular(20),
                              ),
                      ),
                      controller.isLoadingRecent
                          ? SpinKitSquareCircle(color: cs.primary)
                          : Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 4),
                              child: TitledScrollingCard(
                                //minHeight: 250,
                                radius: 20,
                                title: "recent delivery".tr,
                                isEmpty: controller.recentOrders.isEmpty,
                                onClickSeeAll: () {
                                  controller.setOrderType("type", true, selectAll: true);
                                },
                                itemCount: controller.recentOrders.length,
                                children: List.generate(
                                  controller.recentOrders.length,
                                  (i) => OrderCard2(
                                    order: controller.recentOrders[i],
                                    isCustomer: true,
                                    isLast: i == controller.recentOrders.length - 1,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   child: CustomDropdown(
//     title: "order type".tr,
//     items: controller.orderTypes,
//     onSelect: (String? type) {
//       controller.setOrderType(type);
//     },
//     selectedValue: controller.selectedOrderType,
//     icon: Icons.filter_list,
//   ),
// ),
