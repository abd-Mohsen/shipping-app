import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/filter_controller.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/filter_button.dart';
import 'package:shipment/views/components/my_loading_animation.dart';
import '../../controllers/notifications_controller.dart';
import '../components/filter_sheet.dart';
import '../components/my_search_field.dart';
import '../components/notification_button.dart';
import '../components/order_card.dart';

class MyOrdersTab extends StatelessWidget {
  const MyOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    SharedHomeController sHC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<SharedHomeController>(
      builder: (controller) {
        return Stack(
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 3,
            //   child: ColorFiltered(
            //     colorFilter: ColorFilter.mode(
            //       cs.primary.withOpacity(0.7),
            //       BlendMode.srcATop, // Replaces all colors with solid red
            //     ),
            //     child: Image.asset(
            //       "assets/images/background.jpg",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: AppBar(
                    backgroundColor: cs.surface,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent, // Add this line
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: cs.surface, // Match your AppBar
                    ),
                    centerTitle: true,
                    // leading: IconButton(
                    //   onPressed: () {
                    //     controller.homeNavigationController.changeTab(0);
                    //   },
                    //   icon: Icon(
                    //     Icons.arrow_back,
                    //     color: cs.onSurface,
                    //   ),
                    // ),
                    actions: [
                      GetBuilder<NotificationsController>(
                        builder: (innerController) {
                          return NotificationButton(
                            showBadge: innerController.unreadCount > 0,
                            color: cs.onSecondaryContainer,
                          );
                        },
                      ),
                    ],
                    title: Text(
                      "my orders".tr,
                      style: tt.titleMedium!.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     IconButton(
                //       onPressed: () {
                //         controller.homeNavigationController.changeTab(1);
                //       },
                //       icon: Icon(
                //         Icons.arrow_back,
                //         color: cs.onSurface,
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 36, bottom: 20, left: 20, right: 20),
                //       child: Text(
                //         "orders".tr,
                //         style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: MySearchField(
                          label: "search".tr,
                          textEditingController: controller.searchQueryMyOrders,
                          icon: Icon(Icons.search, color: cs.primaryContainer),
                          onChanged: (s) {
                            controller.searchMyOrders();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GetBuilder<FilterController>(
                      builder: (controller) {
                        return FilterButton(
                          showBadge: controller.isFilterApplied,
                          sheet: FilterSheet(
                            showGovernorate: true,
                            showPrice: true,
                            showVehicleType: true,
                            onConfirm: () {
                              Get.back();
                              sHC.refreshOrders();
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 14,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          controller.orderTypes.length + 1,
                          (i) => GestureDetector(
                            onTap: () {
                              i == controller.orderTypes.length
                                  ? controller.setOrderType("type", false, selectAll: true)
                                  : controller.setOrderType(controller.orderTypes[i], false);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2), // Shadow color
                                    blurRadius: 2, // Soften the shadow
                                    spreadRadius: 1, // Extend the shadow
                                    offset: const Offset(1, 1), // Shadow direction (x, y)
                                  ),
                                ],
                                color: i == controller.orderTypes.length
                                    ? controller.selectedOrderTypes.length == controller.orderTypes.length
                                        ? cs.primary
                                        : cs.surface
                                    : controller.selectedOrderTypes.contains(controller.orderTypes[i]) &&
                                            controller.selectedOrderTypes.length != controller.orderTypes.length
                                        ? cs.primary
                                        : cs.surface,
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(
                                //   color: cs.onSurface.withValues(alpha: 0.2),
                                //   width: 0.5,
                                // ),
                              ),
                              child: Row(
                                children: [
                                  if (i != controller.orderTypes.length)
                                    Icon(
                                      controller.orderIcons[i],
                                      color: controller.selectedOrderTypes.contains(controller.orderTypes[i]) &&
                                              controller.selectedOrderTypes.length != controller.orderTypes.length
                                          ? cs.onPrimary
                                          : cs.onSurface,
                                      size: 16,
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    i == controller.orderTypes.length ? "all".tr : controller.orderTypes[i].tr,
                                    style: tt.labelSmall!.copyWith(
                                      color: i == controller.orderTypes.length
                                          ? controller.selectedOrderTypes.length == controller.orderTypes.length
                                              ? cs.onPrimary
                                              : cs.onSurface
                                          : controller.selectedOrderTypes.contains(controller.orderTypes[i]) &&
                                                  controller.selectedOrderTypes.length != controller.orderTypes.length
                                              ? cs.onPrimary
                                              : cs.onSurface,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).reversed.toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                    child: controller.isLoading && controller.page == 1
                        ? SpinKitSquareCircle(color: cs.primary)
                        : RefreshIndicator(
                            onRefresh: controller.refreshOrders,
                            child: controller.myOrders.isEmpty
                                ? const MyLoadingAnimation()
                                : ListView.builder(
                                    controller: controller.myOrdersScrollController,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    itemCount: controller.myOrders.length + 1,
                                    itemBuilder: (context, i) => i < controller.myOrders.length
                                        ? OrderCard(
                                            order: controller.myOrders[i],
                                            isCustomer: true,
                                            //isLast: i == controller.myOrders.length - 1,
                                          )
                                        : Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 24),
                                              child: controller.hasMore
                                                  ? CircularProgressIndicator(color: cs.primary)
                                                  : CircleAvatar(
                                                      radius: 5,
                                                      backgroundColor: cs.onSurface.withValues(alpha: 0.7),
                                                    ),
                                            ),
                                          ),
                                  ),
                          ),
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
