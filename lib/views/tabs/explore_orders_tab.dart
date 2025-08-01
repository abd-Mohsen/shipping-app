import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/filter_sheet.dart';
import 'package:shipment/views/components/governorate_selector.dart';
import 'package:shipment/views/components/my_loading_animation.dart';
import '../../controllers/filter_controller.dart';
import '../../controllers/notifications_controller.dart';
import '../components/filter_button.dart';
import '../components/my_search_field.dart';
import '../components/notification_button.dart';
import '../components/order_card.dart';

class ExploreOrdersTab extends StatelessWidget {
  const ExploreOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    //DriverHomeController hC = Get.find();
    SharedHomeController sHC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<SharedHomeController>(builder: (controller) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              //     controller.homeNavigationController.changeTab(1);
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
                "new order".tr,
                style: tt.titleMedium!.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: controller.isLoadingGovernorates
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SpinKitThreeBounce(color: cs.primary, size: 20),
                  )
                : controller.selectedGovernorate == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.getGovernorates();
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                          ),
                          child: Text(
                            'خطأ, انقر للتحديث',
                            style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 32, bottom: 12, left: 8, right: 8),
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.circle, size: 10, color: cs.onSurface),
                          //       const SizedBox(width: 8),
                          //       Text(
                          //         "show orders in governorate:".tr,
                          //         style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                          //         textAlign: TextAlign.start,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                                  child: MySearchField(
                                    label: "search".tr,
                                    textEditingController: controller.searchQueryExploreOrders,
                                    icon: Padding(
                                      padding: const EdgeInsets.only(right: 20.0, left: 12),
                                      child: Icon(Icons.search, color: cs.primary),
                                    ),
                                    onChanged: (s) {
                                      controller.search(explore: true);
                                    },
                                  ),
                                ),
                              ),
                              GetBuilder<FilterController>(builder: (controller) {
                                return FilterButton(
                                  showBadge: controller.isFilterApplied,
                                  sheet: FilterSheet(
                                    showGovernorate: false,
                                    showPrice: false,
                                    showVehicleType: true,
                                    onConfirm: () {
                                      Get.back();
                                      sHC.refreshExploreOrders();
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GovernorateSelector(
                              selectedItem: controller.selectedGovernorate,
                              items: controller.governorates,
                              onChanged: (g) {
                                controller.setGovernorate(g);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Divider(
                              color: cs.onSurface.withValues(alpha: 0.2),
                              thickness: 1.5,
                              indent: screenWidth / 4,
                              endIndent: screenWidth / 4,
                            ),
                          )
                        ],
                      ),
          ),
          //
          Expanded(
            child: controller.isLoadingExplore && controller.pageExplore == 1
                ? SpinKitSquareCircle(color: cs.primary)
                : RefreshIndicator(
                    onRefresh: controller.refreshExploreOrders,
                    child: controller.exploreOrders.isEmpty
                        ? MyLoadingAnimation(file: "search", height: 300)
                        : ListView.builder(
                            controller: controller.exploreOrdersScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            itemCount: controller.exploreOrders.length + 1,
                            itemBuilder: (context, i) => i < controller.exploreOrders.length
                                ? OrderCard(
                                    order: controller.exploreOrders[i],
                                    isCustomer: false,
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 24),
                                      child: controller.hasMoreExplore
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
        ],
      );
    });
  }
}
