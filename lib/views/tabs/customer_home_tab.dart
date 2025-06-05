import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/views/components/curr_order_card.dart';
import 'package:shipment/views/components/selection_circle.dart';
import 'package:shipment/views/components/titled_card.dart';
import 'package:shipment/views/components/titled_scrolling_card.dart';
import 'package:shipment/views/components/user_profile_tile.dart';
import '../components/order_card_2.dart';

class CustomerHomeTab extends StatelessWidget {
  const CustomerHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CustomerHomeController>(
      builder: (controller) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: UserProfileTile(
                onTapProfile: () {
                  controller.scaffoldKey.currentState?.openDrawer();
                },
                isLoadingUser: controller.isLoadingUser,
                user: controller.currentUser,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                child: TitledCard(
                  title: "orders status".tr,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SelectionCircle(
                        iconData: Icons.done,
                        title: "not taken".tr,
                        isSelected: false,
                        onTap: () {
                          controller.setOrderType("not taken", true);
                        },
                      ),
                      SelectionCircle(
                        iconData: Icons.watch_later_outlined,
                        title: "taken".tr,
                        isSelected: false,
                        onTap: () {
                          controller.setOrderType("taken", true);
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: controller.isLoadingRecent
                    ? SpinKitThreeBounce(color: cs.surface, size: 20)
                    : CurrOrderCard(
                        order: controller.currentOrder,
                        borderRadius: BorderRadius.circular(10),
                      ),
              ),
            ),
            // This is the scrollable section
            SliverFillRemaining(
              child: controller.isLoadingRecent
                  ? SpinKitSquareCircle(color: cs.primary)
                  : Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                      child: RefreshIndicator(
                        onRefresh: controller.refreshRecentOrders,
                        child: TitledScrollingCard(
                          title: "recent delivery".tr,
                          content: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            itemCount: controller.recentOrders.length,
                            itemBuilder: (context, i) => OrderCard2(
                              order: controller.recentOrders[i],
                              isCustomer: true,
                              isLast: i == controller.recentOrders.length - 1,
                            ),
                          ),
                          isEmpty: controller.recentOrders.isEmpty,
                          onClickSeeAll: () {
                            controller.setOrderType("type", true, selectAll: true);
                          },
                        ),
                      ),
                    ),
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
