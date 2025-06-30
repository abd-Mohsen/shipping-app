import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/curr_order_card.dart';
import 'package:shipment/views/components/selection_circle.dart';
import 'package:shipment/views/components/titled_card.dart';
import 'package:shipment/views/components/titled_scrolling_card.dart';
import 'package:shipment/views/components/user_profile_tile.dart';
import '../components/order_card_2.dart';

class CompanyHomeTab extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CompanyHomeTab({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    //CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    //TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<SharedHomeController>(
      //init: HomeController(),
      builder: (controller) {
        return ListView(
          children: [
            GetBuilder<CurrentUserController>(builder: (innerController) {
              return UserProfileTile(
                onTapProfile: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                isLoadingUser: innerController.isLoadingUser,
                user: innerController.currentUser,
              );
            }),
            Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                child: TitledCard(
                  title: "orders status".tr,
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
                )),
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
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
            //   child: Card(
            //     color: cs.secondaryContainer,
            //     elevation: 2,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //       child: Column(
            //         children: [
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Text(
            //                 "Current Shipping",
            //                 style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
            //               ),
            //             ],
            //           ),
            //           Divider(color: cs.onSurface.withOpacity(0.4)),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(vertical: 4),
            //                     child: Text(
            //                       "pick up truck - #1567",
            //                       style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.5)),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Container(
            //                 decoration: BoxDecoration(
            //                   color:
            //                       // order.status == "canceled"
            //                       //     ? Color.lerp(cs.primary, Colors.white, 0.22)
            //                       //     : order.status == "done"
            //                       //         ? Color.lerp(Colors.green, Colors.white, 0.15)
            //                       //         : order.status == "processing"
            //                       //             ? Color.lerp(Colors.blue, Colors.white, 0.5)
            //                       //             :
            //                       Color.lerp(Colors.black, Colors.white, 0.55),
            //                   borderRadius: BorderRadius.circular(20),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            //                   child: Text(
            //                     "pending",
            //                     maxLines: 1,
            //                     overflow: TextOverflow.ellipsis,
            //                     style: tt.labelSmall!.copyWith(
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           SizedBox(height: 4),
            //           SizedBox(
            //             height: 75,
            //             //width: double.infinity,
            //             child: EasyStepper(
            //               activeStep: 2,
            //               padding: const EdgeInsets.symmetric(vertical: 0),
            //               activeStepTextColor: cs.primary,
            //               finishedStepTextColor: cs.onSurface,
            //               unreachedStepTextColor: cs.onSurface.withOpacity(0.7),
            //               internalPadding: 0, // Removes padding around the whole stepper
            //               showLoadingAnimation: false,
            //               stepRadius: 15, // Should match your CircleAvatar radius
            //               showStepBorder: false,
            //               steps: List.generate(
            //                 4,
            //                 (i) => EasyStep(
            //                   customStep: CircleAvatar(
            //                     radius: 14,
            //                     backgroundColor: 2 >= i ? Color.lerp(cs.primary, Colors.white, 0.1) : Colors.grey,
            //                     child: FaIcon(
            //                       stepperIcons[i],
            //                       size: 13,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                   customTitle: Text(
            //                     controller.orderTypes[i].tr,
            //                     style: tt.labelSmall!.copyWith(color: cs.onSurface, fontSize: 10),
            //                     maxLines: 2,
            //                     overflow: TextOverflow.ellipsis,
            //                     textAlign: TextAlign.center,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.width / 3,
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "15/5/2025",
            //                       style: tt.labelSmall!.copyWith(
            //                         color: cs.onSurface.withOpacity(0.6),
            //                       ),
            //                     ),
            //                     const SizedBox(height: 2),
            //                     Text(
            //                       "دمشق, ركن الدين",
            //                       style: tt.labelSmall!.copyWith(
            //                         color: cs.onSurface,
            //                       ),
            //                       maxLines: 2,
            //                       overflow: TextOverflow.ellipsis,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.width / 3,
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.end,
            //                   children: [
            //                     Text(
            //                       "18/5/2025",
            //                       style: tt.labelSmall!.copyWith(
            //                         color: cs.onSurface.withOpacity(0.6),
            //                       ),
            //                     ),
            //                     const SizedBox(height: 2),
            //                     Text(
            //                       "ريف دمشق, حرستا",
            //                       style: tt.labelSmall!.copyWith(
            //                         color: cs.onSurface,
            //                       ),
            //                       maxLines: 2,
            //                       overflow: TextOverflow.ellipsis,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.currOrders.isEmpty ? 1 : controller.currOrders.length,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: controller.isLoadingRecent
                        ? SpinKitThreeBounce(color: cs.surface, size: 20)
                        : CurrOrderCard(
                            order: controller.currOrders.isEmpty ? null : controller.currOrders[i],
                            borderRadius: BorderRadius.circular(10),
                          ),
                  ),
                ),
              ),
            ),

            controller.isLoadingRecent
                ? SpinKitSquareCircle(color: cs.primary)
                : Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                    child: TitledScrollingCard(
                      //minHeight: 250,
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
        );
      },
    );
  }
}
