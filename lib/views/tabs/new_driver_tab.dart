import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/my_loading_animation.dart';
import 'package:shipment/views/components/user_profile_tile.dart';
import '../components/count_up_timer.dart';
import '../components/governorate_selector.dart';
import '../components/order_card_2.dart';

class NewDriverTab extends StatelessWidget {
  const NewDriverTab({super.key});

  @override
  Widget build(BuildContext context) {
    //DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<DriverHomeController>(
      //init: HomeController(),
      builder: (controller) {
        return SafeArea(
          child: Stack(
            children: [
              FlutterMap(
                mapController: controller.mapController,
                options: const MapOptions(
                  initialCenter: LatLng(52.518611, 13.408056),
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    //urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    urlTemplate: "https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                    // urlTemplate: "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=",
                  ),
                  MarkerLayer(
                    markers: controller.currMarkers,
                  ),
                  if (controller.road.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: controller.road,
                          strokeWidth: 4.0,
                          color: cs.primary,
                        ),
                      ],
                    ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GetBuilder<CurrentUserController>(builder: (innerController) {
                  return UserProfileTile(
                    onTapProfile: () {
                      innerController.scaffoldKey.currentState?.openDrawer();
                    },
                    locationIndicator: controller.trackingID == 1 ? null : controller.trackingStatus,
                    isLoadingUser: innerController.isLoadingUser,
                    user: innerController.currentUser,
                    isPrimaryColor: false,
                    showBadge: innerController.currentUser != null &&
                        innerController.currentUser!.role.type == "driver" &&
                        ["refused", "No_Input"].contains(innerController.currentUser!.driverInfo?.vehicleStatus),
                  );
                }),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(100),
                        child: GestureDetector(
                          onTap: () {
                            controller.pointToMyLocation();
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: cs.primary,
                            foregroundColor: cs.onPrimary,
                            child: const Icon(Icons.my_location_outlined, size: 22),
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      height: controller.containerHeight,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        color: cs.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2), // Shadow color
                            blurRadius: 5, // Soften the shadow
                            spreadRadius: 2, // Extend the shadow
                            offset: const Offset(-2, -2), // Shadow direction (x, y)
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: GetBuilder<SharedHomeController>(
                        builder: (innerController) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  child: Divider(
                                    thickness: 2,
                                    color: cs.onSurface,
                                    indent: 170,
                                    endIndent: 170,
                                  ),
                                  onTap: () {
                                    print("tap");
                                  },
                                  // onPanStart: (details) {
                                  //   print('Pan started');
                                  // },
                                  // onPanEnd: (details) {
                                  //   print('Pan ended');
                                  //   // You can use velocity here to infer drag direction
                                  //   if (details.velocity.pixelsPerSecond.dy > 0) {
                                  //     controller.foldContainer();
                                  //   } else {
                                  //     controller.expandContainer();
                                  //   }
                                  // },
                                  onVerticalDragUpdate: (details) {
                                    if (details.delta.dy > 0) {
                                      controller.foldContainer();
                                    } else if (details.delta.dy < 0) {
                                      controller.expandContainer();
                                    }
                                  },
                                  // onLongPressDown: (_) {
                                  //   controller.foldContainer();
                                  // },
                                ),
                                Expanded(
                                  child: innerController.currOrders.isNotEmpty
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
                                                    "#${innerController.currOrders.first.id}",
                                                    style: tt.titleMedium!.copyWith(
                                                      color: cs.onSurface.withValues(alpha: 0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: SingleChildScrollView(
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
                                                      padding:
                                                          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                                                      //todo: pass begin time instead of creation time
                                                      child: CountUpTimer(
                                                        startDuration: DateTime.now()
                                                            .difference(innerController.currOrders.first.createdAt),
                                                        textStyle: tt.headlineLarge!
                                                            .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                                      ),
                                                      // child: Text(
                                                      //   "00 : 23 : 01".tr,
                                                      //   style: tt.headlineLarge!.copyWith(
                                                      //     color: cs.onSurface,
                                                      //   ),
                                                      // ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                const Icon(Icons.location_on,
                                                                    size: 20, color: Color(0xFFFF0000)),
                                                                Text(
                                                                  "from".tr,
                                                                  style: tt.labelMedium!.copyWith(
                                                                      color: cs.onSurface.withValues(alpha: 0.6)),
                                                                ),
                                                                const SizedBox(width: 4),
                                                                Expanded(
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      controller.drawPath(
                                                                        true,
                                                                        LatLng(
                                                                          innerController
                                                                              .currOrders.first.startPoint.latitude,
                                                                          innerController
                                                                              .currOrders.first.startPoint.longitude,
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                      innerController.currOrders.first.startPoint
                                                                          .toString(),
                                                                      style: tt.labelMedium!.copyWith(
                                                                        color: Colors.blue,
                                                                        decoration: TextDecoration.underline,
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                const Icon(Icons.location_on,
                                                                    size: 20, color: Color(0xFF38B6FF)),
                                                                Text(
                                                                  "to".tr,
                                                                  style: tt.labelMedium!.copyWith(
                                                                      color: cs.onSurface.withValues(alpha: 0.6)),
                                                                ),
                                                                const SizedBox(width: 4),
                                                                Expanded(
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      controller.drawPath(
                                                                        false,
                                                                        LatLng(
                                                                          innerController
                                                                              .currOrders.first.endPoint.latitude,
                                                                          innerController
                                                                              .currOrders.first.endPoint.longitude,
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                      innerController.currOrders.first.endPoint
                                                                          .toString(),
                                                                      style: tt.labelMedium!.copyWith(
                                                                        color: Colors.blue,
                                                                        decoration: TextDecoration.underline,
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                      child: OrderCard2(
                                                        order: innerController.recentOrders.first,
                                                        isCustomer: false,
                                                        isLast: true,
                                                        color: cs.surface,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
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
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: innerController.isLoadingGovernorates
                                                  ? Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                      child: SpinKitThreeBounce(color: cs.primary, size: 20),
                                                    )
                                                  : innerController.selectedGovernorate == null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              innerController.getGovernorates();
                                                            },
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  WidgetStateProperty.all<Color>(cs.primary),
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
                                                                selectedItem: innerController.selectedGovernorate,
                                                                items: innerController.governorates,
                                                                onChanged: (g) {
                                                                  innerController.setGovernorate(g);
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
                                              child: innerController.isLoadingExplore &&
                                                      innerController.pageExplore == 1
                                                  ? SpinKitSquareCircle(color: cs.primary)
                                                  : innerController.exploreOrders.isEmpty
                                                      ? const MyLoadingAnimation(height: 80, title: "no data")
                                                      : NotificationListener<ScrollNotification>(
                                                          onNotification: (notification) {
                                                            if (notification is UserScrollNotification) {
                                                              final direction = notification.direction;
                                                              final offset =
                                                                  controller.mapContainerScrollController.offset;
                                                              if (offset <= 0) {
                                                                // At top of list
                                                                controller.isAtTop = true;
                                                                if (!controller.hasReachedTopOnce) {
                                                                  // First time reaching top, just mark it
                                                                  controller.hasReachedTopOnce = true;
                                                                } else if (direction == ScrollDirection.forward &&
                                                                    controller.containerHeight !=
                                                                        controller.baseHeight) {
                                                                  // Second upward scroll while already at top → fold
                                                                  controller.setContainerHeight(controller.baseHeight);
                                                                }
                                                              }
                                                              return true; // handled
                                                            }
                                                            return false;
                                                          },
                                                          child: ListView.builder(
                                                            padding:
                                                                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                            controller: controller.mapContainerScrollController,
                                                            itemCount: innerController.exploreOrders.length + 1,
                                                            itemBuilder: (context, i) => i <
                                                                    innerController.exploreOrders.length
                                                                ? OrderCard2(
                                                                    order: innerController.exploreOrders[i],
                                                                    isCustomer: false,
                                                                    isLast:
                                                                        i == innerController.exploreOrders.length - 1,
                                                                    color: cs.surface,
                                                                  )
                                                                : Center(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 24),
                                                                      child: innerController.hasMoreExplore
                                                                          ? CircularProgressIndicator(color: cs.primary)
                                                                          : CircleAvatar(
                                                                              radius: 5,
                                                                              backgroundColor:
                                                                                  cs.onSurface.withValues(alpha: 0.7),
                                                                            ),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
