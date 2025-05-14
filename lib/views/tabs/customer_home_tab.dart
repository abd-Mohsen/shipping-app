import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:badges/badges.dart' as bdg;
import 'package:shipment/views/components/selection_circle.dart';
import '../../controllers/notifications_controller.dart';
import '../components/order_card_2.dart';
import '../notifications_view.dart';

class CustomerHomeTab extends StatelessWidget {
  const CustomerHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CustomerHomeController>(
      //init: HomeController(),
      builder: (controller) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              decoration: BoxDecoration(
                color: Color.lerp(cs.primary, Colors.white, 0.025),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 0),
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
                            onTap: () {
                              controller.scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color.lerp(cs.primary, Colors.white, 0.33),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.person_outline, color: cs.onPrimary),
                            ),
                          ),
                          //SizedBox(width: 4),
                          controller.isLoadingUser
                              ? SpinKitThreeBounce(color: cs.onPrimary, size: 15)
                              : controller.currentUser == null
                                  ? SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${controller.currentUser!.firstName} ${controller.currentUser!.lastName}",
                                          style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          controller.currentUser!.phoneNumber,
                                          style: tt.labelMedium!.copyWith(color: cs.onPrimary.withOpacity(0.8)),
                                        ),
                                      ],
                                    )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        // todo: use package bagde
                        child: Badge(
                          smallSize: 10,
                          backgroundColor: const Color(0xff00ff00),
                          alignment: Alignment.topRight,
                          offset: const Offset(-5, -5),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const NotificationsView());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Color.lerp(cs.primary, Colors.white, 0.33),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: GetBuilder<NotificationsController>(
                                builder: (controller) {
                                  return Icon(
                                    Icons.notifications_outlined,
                                    color: cs.onPrimary,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.lerp(cs.primary, Colors.black, 0.22),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.wallet_outlined, color: cs.onPrimary),
                        SizedBox(width: 12),
                        Text(
                          controller.isLoadingUser ? "0.00" : controller.currentUser?.wallet?.balance ?? "0.00",
                          style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              child: Card(
                color: cs.secondaryContainer,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SelectionCircle(
                        iconData: Icons.watch_later_outlined,
                        title: "not taken".tr,
                        isSelected: controller.selectedOrderType == "not taken",
                        onTap: () {
                          controller.setOrderType("not taken");
                        },
                      ),
                      SelectionCircle(
                        iconData: Icons.watch_later_outlined,
                        title: "taken".tr,
                        isSelected: controller.selectedOrderType == "taken",
                        onTap: () {
                          controller.setOrderType("taken");
                        },
                      ),
                      SelectionCircle(
                        iconData: Icons.local_shipping_outlined,
                        title: "current".tr,
                        isSelected: controller.selectedOrderType == "current",
                        onTap: () {
                          controller.setOrderType("current");
                        },
                      ),
                      SelectionCircle(
                        iconData: Icons.check,
                        title: "finished".tr,
                        isSelected: controller.selectedOrderType == "finished",
                        onTap: () {
                          controller.setOrderType("finished");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
            Expanded(
              child: controller.isLoading
                  ? SpinKitSquareCircle(color: cs.primary)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: RefreshIndicator(
                        onRefresh: controller.refreshOrders,
                        child: controller.myOrders.isEmpty
                            ? Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset("assets/animations/simple truck.json", height: 200),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Center(
                                        child: Text(
                                          "no data, pull down to refresh".tr,
                                          style: tt.titleMedium!.copyWith(
                                            color: cs.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 72),
                                  ],
                                ),
                              )
                            : Card(
                                elevation: 5,
                                color: cs.secondaryContainer,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                                          child: Text(
                                            "Recent Delivery",
                                            style: tt.titleSmall!
                                                .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                                            child: Text(
                                              "see all",
                                              style: tt.titleSmall!.copyWith(color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        itemCount: controller.myOrders.length,
                                        itemBuilder: (context, i) => OrderCard2(
                                          order: controller.myOrders[i],
                                          isCustomer: true,
                                          isLast: i == controller.myOrders.length - 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
