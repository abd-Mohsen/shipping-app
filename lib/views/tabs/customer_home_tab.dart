import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    List<IconData> stepperIcons = [
      Icons.done,
      Icons.watch_later,
      FontAwesomeIcons.truck,
      Icons.done_all,
    ];

    return GetBuilder<CustomerHomeController>(
      //init: HomeController(),
      builder: (controller) {
        return Column(
          children: [
            //todo: extract first 2 packages
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 10),
              decoration: BoxDecoration(
                color: Color.lerp(cs.primary, Colors.white, 0.025),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
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
              padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
              child: Card(
                color: cs.secondaryContainer,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            // controller.isLoading
            //     ? SpinKitThreeBounce(color: cs.primary, size: 20)
            //     : Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 12),
            //         child: RefreshIndicator(
            //           onRefresh: controller.refreshOrders,
            //           child: controller.myOrders.isEmpty
            //               ? Center(
            //                   child: ListView(
            //                     shrinkWrap: true,
            //                     //mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       //Lottie.asset("assets/animations/simple truck.json", height: 200),
            //                       Padding(
            //                         padding: const EdgeInsets.all(4),
            //                         child: Center(
            //                           child: Text(
            //                             "no data, pull down to refresh".tr,
            //                             style: tt.titleMedium!.copyWith(
            //                               color: cs.onSurface,
            //                               fontWeight: FontWeight.bold,
            //                             ),
            //                             textAlign: TextAlign.center,
            //                           ),
            //                         ),
            //                       ),
            //                       const SizedBox(height: 72),
            //                     ],
            //                   ),
            //                 )
            //               : Card(
            //                   elevation: 5,
            //                   color: cs.secondaryContainer,
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Padding(
            //                             padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            //                             child: Text(
            //                               "Recent Delivery",
            //                               style:
            //                                   tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
            //                             ),
            //                           ),
            //                           GestureDetector(
            //                             child: Padding(
            //                               padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            //                               child: Text(
            //                                 "see all",
            //                                 style: tt.titleSmall!.copyWith(color: Colors.blue),
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       Expanded(
            //                         child: ListView.builder(
            //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //                           itemCount: controller.myOrders.length,
            //                           itemBuilder: (context, i) => OrderCard2(
            //                             order: controller.myOrders[i],
            //                             isCustomer: true,
            //                             isLast: i == controller.myOrders.length - 1,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //         ),
            //       ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
              child: Card(
                color: cs.secondaryContainer,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Current Shipping",
                            style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(color: cs.onSurface.withOpacity(0.4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  "pick up truck - #1567",
                                  style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.5)),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  // order.status == "canceled"
                                  //     ? Color.lerp(cs.primary, Colors.white, 0.22)
                                  //     : order.status == "done"
                                  //         ? Color.lerp(Colors.green, Colors.white, 0.15)
                                  //         : order.status == "processing"
                                  //             ? Color.lerp(Colors.blue, Colors.white, 0.5)
                                  //             :
                                  Color.lerp(Colors.black, Colors.white, 0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                              child: Text(
                                "pending",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tt.labelSmall!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        height: 75,
                        //width: double.infinity,
                        child: EasyStepper(
                          activeStep: 2,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          activeStepTextColor: cs.primary,
                          finishedStepTextColor: cs.onSurface,
                          unreachedStepTextColor: cs.onSurface.withOpacity(0.7),
                          internalPadding: 0, // Removes padding around the whole stepper
                          showLoadingAnimation: false,
                          stepRadius: 15, // Should match your CircleAvatar radius
                          showStepBorder: false,
                          steps: List.generate(
                            4,
                            (i) => EasyStep(
                              customStep: CircleAvatar(
                                radius: 14,
                                backgroundColor: 2 >= i ? Color.lerp(cs.primary, Colors.white, 0.1) : Colors.grey,
                                child: FaIcon(
                                  stepperIcons[i],
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                              customTitle: Text(
                                controller.orderTypes[i].tr,
                                style: tt.labelSmall!.copyWith(color: cs.onSurface, fontSize: 10),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "15/5/2025",
                                  style: tt.labelSmall!.copyWith(
                                    color: cs.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "دمشق, ركن الدين",
                                  style: tt.labelSmall!.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "18/5/2025",
                                  style: tt.labelSmall!.copyWith(
                                    color: cs.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "ريف دمشق, حرستا",
                                  style: tt.labelSmall!.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: controller.isLoadingRecent
                  ? SpinKitSquareCircle(color: cs.primary)
                  : Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                      child: RefreshIndicator(
                        onRefresh: controller.refreshRecentOrders,
                        child: Card(
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
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.setOrderType("type", true, selectAll: true);
                                    },
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
