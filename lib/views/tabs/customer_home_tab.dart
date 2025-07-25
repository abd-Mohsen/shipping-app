import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/curr_order_card.dart';
import 'package:shipment/views/components/selection_circle.dart';
import 'package:shipment/views/components/titled_card.dart';
import 'package:shipment/views/components/titled_scrolling_card.dart';
import 'package:shipment/views/components/user_profile_tile.dart';
import '../../controllers/current_user_controller.dart';
import '../components/order_card_2.dart';
import '../components/order_page_map.dart';

class CustomerHomeTab extends StatelessWidget {
  const CustomerHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    //CustomerHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    //SharedHomeController sHC = Get.find();

    return GetBuilder<SharedHomeController>(
      builder: (controller) {
        return ListView(
          children: [
            GetBuilder<CurrentUserController>(builder: (innerController) {
              return UserProfileTile(
                onTapProfile: () {
                  innerController.scaffoldKey.currentState?.openDrawer();
                },
                isLoadingUser: innerController.isLoadingUser,
                user: innerController.currentUser,
                isPrimaryColor: false,
              );
            }),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff0e5aa6), width: 2.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: OrderPageMap(
                        mapController: MapController.withPosition(
                          initPosition: GeoPoint(latitude: 33.5132, longitude: 36.2768),
                        ),
                        onMapIsReady: (v) {
                          //
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //todo: giving errors in console
            //todo: add dots
            CarouselSlider(
              items: List.generate(
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
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  //aspectRatio: 16 / 8,
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height / 3.5), //todo: make it not fixed
            ),
            // This is the scrollable section
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
