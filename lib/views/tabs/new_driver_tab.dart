import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' hide Marker;
import 'package:shipment/constants.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/curr_order_card.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/notification_button.dart';
import 'package:shipment/views/components/titled_card.dart';
import 'package:shipment/views/components/user_profile_tile.dart';
import 'package:shipment/views/my_vehicles_view.dart';
import '../../controllers/filter_controller.dart';
import '../../controllers/notifications_controller.dart';
import '../components/filter_button.dart';
import '../components/filter_sheet.dart';
import '../components/governorate_selector.dart';
import '../components/my_search_field.dart';
import '../components/order_card.dart';
import '../components/order_card_2.dart';
import 'package:badges/badges.dart' as badges;

import '../components/order_card_3.dart';
import '../components/selection_circle.dart';
import '../components/titled_scrolling_card.dart';

class NewDriverTab extends StatelessWidget {
  const NewDriverTab({super.key});

  @override
  Widget build(BuildContext context) {
    //DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<DriverHomeController>(
      //init: HomeController(),
      builder: (controller) {
        return SafeArea(
          child: Stack(
            children: [
              FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: LatLng(52.518611, 13.408056),
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    //urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    urlTemplate: "https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                    // urlTemplate: "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=CPMtVdB0p80R8FxJ8jdU",
                  ),
                  MarkerLayer(
                    markers: controller.currMarkers,
                  ),
                ],
              ),
              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(top: 8),
              //       child: Column(
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               // GetBuilder<CurrentUserController>(
              //               //   builder: (innerController) {
              //               //     return Row(
              //               //       children: [
              //               //         GestureDetector(
              //               //           onTap: () {
              //               //             innerController.scaffoldKey.currentState?.openDrawer();
              //               //           },
              //               //           child: Padding(
              //               //             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              //               //             child: badges.Badge(
              //               //               showBadge: innerController.currentUser != null &&
              //               //                   innerController.currentUser!.role.type == "driver" &&
              //               //                   ["refused", "No_Input"]
              //               //                       .contains(innerController.currentUser!.driverInfo?.vehicleStatus),
              //               //               position: badges.BadgePosition.topStart(
              //               //                 top: -2, // Negative value moves it up
              //               //                 start: -4, // Negative value moves it left
              //               //               ),
              //               //               badgeStyle: badges.BadgeStyle(
              //               //                 shape: badges.BadgeShape.circle,
              //               //                 badgeColor: kNotificationColor,
              //               //                 borderRadius: BorderRadius.circular(4),
              //               //               ),
              //               //               child: Container(
              //               //                 padding: const EdgeInsets.all(6),
              //               //                 decoration: BoxDecoration(
              //               //                   color: Color.lerp(cs.primary, Colors.white, 0.33),
              //               //                   borderRadius: BorderRadius.circular(8),
              //               //                 ),
              //               //                 child: Icon(Icons.person_outline, color: cs.onPrimary),
              //               //               ),
              //               //             ),
              //               //           ),
              //               //         ),
              //               //         //SizedBox(width: 4),
              //               //         innerController.isLoadingUser
              //               //             ? SpinKitThreeBounce(color: cs.onPrimary, size: 15)
              //               //             : innerController.currentUser == null
              //               //                 ? const SizedBox.shrink()
              //               //                 : Column(
              //               //                     crossAxisAlignment: CrossAxisAlignment.start,
              //               //                     children: [
              //               //                       Text(
              //               //                         "${innerController.currentUser!.firstName} ${innerController.currentUser!.lastName}",
              //               //                         style: tt.titleSmall!.copyWith(color: cs.onPrimary),
              //               //                       ),
              //               //                       const SizedBox(height: 4),
              //               //                       Text(
              //               //                         innerController.currentUser!.phoneNumber,
              //               //                         style: tt.labelMedium!
              //               //                             .copyWith(color: cs.onPrimary.withValues(alpha: 0.8)),
              //               //                       ),
              //               //                     ],
              //               //                   )
              //               //       ],
              //               //     );
              //               //   },
              //               // ),
              //               // GetBuilder<NotificationsController>(
              //               //   builder: (innerController) {
              //               //     return NotificationButton(
              //               //       showBadge: innerController.unreadCount > 0,
              //               //       color: cs.onPrimary,
              //               //     );
              //               //   },
              //               // ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
              //       child: Text(
              //         "Tracking status".tr,
              //         style: tt.titleSmall!.copyWith(color: cs.onPrimary, fontWeight: FontWeight.normal),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
              //       child: GestureDetector(
              //         onTap: () {
              //           controller.reconnectTracking();
              //         },
              //         child: Card(
              //           color: Color.lerp(cs.primary, Colors.white, 0.33),
              //           elevation: 5,
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //             child: Row(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               children: [
              //                 Icon(
              //                   Icons.location_on_outlined,
              //                   color: controller.trackingStatus == "tracking" ? const Color(0xff00ff00) : cs.primary,
              //                 ),
              //                 const SizedBox(width: 12),
              //                 Expanded(
              //                   //width: MediaQuery.of(context).size.width / 1.2,
              //                   child: Text(
              //                     controller.trackingStatus.tr,
              //                     style: tt.titleSmall!.copyWith(color: cs.onPrimary),
              //                     maxLines: 2,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     //
              //     GetBuilder<CurrentUserController>(
              //       builder: (innerController) {
              //         return Visibility(
              //           visible: innerController.currentUser != null &&
              //               innerController.currentUser!.role.type == "driver" &&
              //               ["refused", "No_Input"].contains(innerController.currentUser!.driverInfo?.vehicleStatus),
              //           child: GestureDetector(
              //             onTap: () {
              //               Get.to(const MyVehiclesView(openSheet: true));
              //             },
              //             child: Container(
              //               padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
              //               margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 gradient: const LinearGradient(
              //                   colors: [
              //                     Color(0xFFF5E5C4),
              //                     Color(0xFFF1C68B),
              //                   ],
              //                   begin: Alignment.topCenter,
              //                   end: Alignment.bottomCenter,
              //                   stops: [0, 1],
              //                 ),
              //               ),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Row(
              //                     children: [
              //                       const Icon(
              //                         Icons.warning_amber,
              //                         color: Color(0xFF92833C),
              //                         size: 30,
              //                       ),
              //                       const SizedBox(width: 12),
              //                       Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             "you dont have a vehicle".tr,
              //                             style: tt.titleSmall!
              //                                 .copyWith(color: const Color(0xFF92833C), fontWeight: FontWeight.bold),
              //                           ),
              //                           SizedBox(height: 4),
              //                           Text(
              //                             "click here to go to vehicles page".tr,
              //                             style: tt.labelMedium!.copyWith(color: const Color(0xFF92833C)),
              //                           ),
              //                         ],
              //                       )
              //                     ],
              //                   ),
              //                   const Icon(
              //                     Icons.add,
              //                     color: Color(0xFF92833C),
              //                     size: 35,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: AppBar(
              //     backgroundColor: Colors.transparent,
              //     elevation: 0,
              //     centerTitle: true,
              //     actions: [
              //       GetBuilder<NotificationsController>(
              //         builder: (innerController) {
              //           return NotificationButton(
              //             showBadge: innerController.unreadCount > 0,
              //             color: cs.onSecondaryContainer,
              //           );
              //         },
              //       ),
              //     ],
              //     title: Padding(
              //       padding: const EdgeInsets.only(top: 16.0),
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              //         margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 4),
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           color: cs.secondaryContainer,
              //           borderRadius: BorderRadius.circular(12),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black.withValues(alpha: 0.2), // Shadow color
              //               blurRadius: 3, // Soften the shadow
              //               spreadRadius: 2, // Extend the shadow
              //               offset: Offset(2, 1), // Shadow direction (x, y)
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "balance",
              //                 style: tt.labelMedium!.copyWith(color: cs.onSecondaryContainer),
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.start,
              //                 children: [
              //                   Icon(Icons.wallet_outlined, color: cs.primary),
              //                   SizedBox(width: 12),
              //                   Text(
              //                     "0.00",
              //                     style: tt.titleSmall!.copyWith(color: cs.onSecondaryContainer),
              //                   )
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: 10,
              //   right: 0,
              //   left: 0,
              //   child: Container(
              //     child: GestureDetector(
              //       onTap: () {
              //         //if (cUC.currentUser != null) Get.to(InvoicesView(user: cUC.currentUser!));
              //       },
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              //         margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 4),
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           color: Color.lerp(cs.primary, Colors.black, 0.22),
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             Icon(Icons.wallet_outlined, color: cs.onPrimary),
              //             SizedBox(width: 12),
              //             Text(
              //               "0.00",
              //               style: tt.titleSmall!.copyWith(color: cs.onPrimary),
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GetBuilder<CurrentUserController>(builder: (controller) {
                  return UserProfileTile(
                    onTapProfile: () {},
                    isLoadingUser: controller.isLoadingUser,
                    user: controller.currentUser,
                    isPrimaryColor: false,
                  );
                }),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight / 2.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    color: cs.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2), // Shadow color
                        blurRadius: 5, // Soften the shadow
                        spreadRadius: 2, // Extend the shadow
                        offset: Offset(-2, -2), // Shadow direction (x, y)
                      ),
                    ],
                  ),
                  child: GetBuilder<SharedHomeController>(
                    builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: controller.currOrders.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "current order".tr,
                                          style: tt.titleMedium!.copyWith(
                                            color: cs.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "#${controller.currOrders.first.id}",
                                          style: tt.titleMedium!.copyWith(
                                            color: cs.onSurface.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12.0, left: 12, top: 8),
                                          child: Text(
                                            "duration".tr,
                                            style: tt.titleSmall!.copyWith(
                                              color: cs.onSurface.withValues(alpha: 0.4),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                                          child: Text(
                                            "00 : 23 : 01".tr,
                                            style: tt.headlineLarge!.copyWith(
                                              color: cs.onSurface,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.location_on, size: 20, color: Color(0xFFFF0000)),
                                                    Text(
                                                      "from".tr,
                                                      style: tt.labelMedium!
                                                          .copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      controller.currOrders.first.startPoint.governorate,
                                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.location_on, size: 20, color: Color(0xFF38B6FF)),
                                                    Text(
                                                      "to".tr,
                                                      style: tt.labelMedium!
                                                          .copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      controller.currOrders.first.endPoint.governorate,
                                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                          child: OrderCard3(order: controller.recentOrders.first, isCustomer: false),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  //   child: CustomButton(
                                  //     onTap: () {},
                                  //     child: Center(
                                  //       child: Text(
                                  //         "finish".tr,
                                  //         style: tt.titleSmall!.copyWith(
                                  //           color: cs.onSurface,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                  //   child: Text(
                                  //     "new order".tr,
                                  //     style: tt.titleMedium!.copyWith(
                                  //       color: cs.onSurface,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                                                  // Row(
                                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                                  //   children: [
                                                  //     Expanded(
                                                  //       child: Padding(
                                                  //         padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                                                  //         child: MySearchField(
                                                  //           label: "search".tr,
                                                  //           textEditingController: controller.searchQueryExploreOrders,
                                                  //           icon: Padding(
                                                  //             padding: const EdgeInsets.only(right: 20.0, left: 12),
                                                  //             child: Icon(Icons.search, color: cs.primary),
                                                  //           ),
                                                  //           onChanged: (s) {
                                                  //             controller.search(explore: true);
                                                  //           },
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     // GetBuilder<FilterController>(builder: (controller) {
                                                  //     //   return FilterButton(
                                                  //     //     showBadge: controller.isFilterApplied,
                                                  //     //     sheet: FilterSheet(
                                                  //     //       showGovernorate: false,
                                                  //     //       showPrice: false,
                                                  //     //       showVehicleType: true,
                                                  //     //       onConfirm: () {
                                                  //     //         Get.back();
                                                  //     //         controller.refreshExploreOrders();
                                                  //     //       },
                                                  //     //     ),
                                                  //     //   );
                                                  //     // }),
                                                  //   ],
                                                  // ),
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
                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(top: 16.0),
                                                  //   child: Divider(
                                                  //     color: cs.onSurface.withValues(alpha: 0.2),
                                                  //     thickness: 1.5,
                                                  //     indent: screenWidth / 4,
                                                  //     endIndent: screenWidth / 4,
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                  ),
                                  Expanded(
                                    child: controller.isLoadingExplore
                                        ? SpinKitSquareCircle(color: cs.primary)
                                        : RefreshIndicator(
                                            onRefresh: controller.refreshExploreOrders,
                                            child: controller.exploreOrders.isEmpty
                                                ? Center(
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(24),
                                                          child: Center(
                                                            child: Text(
                                                              "no data, pull down to refresh".tr,
                                                              style: tt.titleMedium!.copyWith(
                                                                  color: cs.onSurface, fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                    itemCount: controller.exploreOrders.length,
                                                    itemBuilder: (context, i) => OrderCard3(
                                                      order: controller.exploreOrders[i],
                                                      isCustomer: false,
                                                    ),
                                                  ),
                                          ),
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
