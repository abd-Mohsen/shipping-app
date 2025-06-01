import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/views/components/curr_order_card.dart';
import 'package:shipment/views/components/selection_circle.dart';
import 'package:shipment/views/components/user_profile_tile.dart';
import '../components/order_card_2.dart';

class CompanyHomeTab extends StatelessWidget {
  const CompanyHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CompanyHomeController>(
      //init: HomeController(),
      builder: (controller) {
        return ListView(
          children: [
            UserProfileTile(
              onTapProfile: () {
                controller.scaffoldKey.currentState?.openDrawer();
              },
              isLoadingUser: controller.isLoadingUser,
              user: controller.currentUser,
              company: true,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
              child: Card(
                color: cs.secondaryContainer,
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                      child: Text(
                        "orders status".tr,
                        style: tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(color: cs.onSurface.withOpacity(0.2)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                      child: Row(
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: controller.isLoadingRecent
                  ? SpinKitThreeBounce(color: cs.surface, size: 20)
                  : CurrOrderCard(
                      order: controller.currentOrder,
                      borderRadius: BorderRadius.circular(10),
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: controller.isLoadingRecent
                  ? SpinKitSquareCircle(color: cs.primary)
                  : Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                      child: RefreshIndicator(
                        onRefresh: controller.refreshRecentOrders,
                        child: Card(
                          elevation: 5,
                          color: cs.secondaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "recent delivery".tr,
                                        style:
                                            tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.setOrderType("type", true, selectAll: true);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          "see all".tr,
                                          style: tt.labelSmall!.copyWith(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(color: cs.onSurface.withOpacity(0.2)),
                                ),
                                controller.recentOrders.isEmpty
                                    ? Expanded(
                                        child: Center(
                                          child: ListView(
                                            shrinkWrap: true,
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              //Lottie.asset("assets/animations/simple truck.json", height: 200),
                                              Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: Center(
                                                  child: Text(
                                                    "no data, pull down to refresh".tr,
                                                    style: tt.titleSmall!.copyWith(
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
                                        ),
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                          //physics: NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          itemCount: controller.recentOrders.length,
                                          itemBuilder: (context, i) => OrderCard2(
                                            order: controller.recentOrders[i],
                                            isCustomer: true,
                                            isLast: i == controller.recentOrders.length - 1,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
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
