// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/curr_order_card.dart';
import 'package:shipment/views/components/my_showcase.dart';
import 'package:shipment/views/components/titled_scrolling_card.dart';
import 'package:shipment/views/components/user_profile_tile.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../controllers/current_user_controller.dart';
import '../components/map_preview_container.dart';
import '../components/order_card_2.dart';
import 'package:get_storage/get_storage.dart';

class CustomerHomeTab extends StatefulWidget {
  const CustomerHomeTab({super.key});

  @override
  State<CustomerHomeTab> createState() => _CustomerHomeTabState();
}

class _CustomerHomeTabState extends State<CustomerHomeTab> {
  final GlobalKey _showKey1 = GlobalKey();
  final GlobalKey _showKey2 = GlobalKey();

  final GetStorage _getStorage = GetStorage();

  final String storageKey = "showcase_customer_home_tab";

  bool get isEnabled => !_getStorage.hasData(storageKey);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEnabled) ShowCaseWidget.of(context).startShowCase([_showKey1, _showKey2]);
      _getStorage.write(storageKey, true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //CustomerHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    //TextTheme tt = Theme.of(context).textTheme;
    //SharedHomeController sHC = Get.find();

    return GetBuilder<SharedHomeController>(
      builder: (controller) {
        return ListView(
          children: [
            GetBuilder<CurrentUserController>(builder: (innerController) {
              return MyShowcase(
                globalKey: _showKey1,
                description: 'here you can see your profile, see notifications and view your balance'.tr,
                enabled: isEnabled,
                child: UserProfileTile(
                  onTapProfile: () {
                    innerController.scaffoldKey.currentState?.openDrawer();
                  },
                  isLoadingUser: innerController.isLoadingUser,
                  user: innerController.currentUser,
                  isPrimaryColor: false,
                ),
              );
            }),
            const MapPreviewContainer(),
            //todo: giving errors in console
            //todo: add dots
            // CarouselSlider(
            //   items: List.generate(
            //     controller.currOrders.isEmpty ? 1 : controller.currOrders.length,
            //     (i) => Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 4),
            //       child: controller.isLoadingRecent
            //           ? SpinKitThreeBounce(color: cs.surface, size: 20)
            //           : CurrOrderCard(
            //               order: controller.currOrders.isEmpty ? null : controller.currOrders[i],
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //     ),
            //   ),
            //   options: CarouselOptions(
            //       enableInfiniteScroll: false,
            //       //aspectRatio: 16 / 8,
            //       viewportFraction: 1,
            //       height: MediaQuery.of(context).size.height / 3.5), //todo: make it not fixed
            // ),
            MyShowcase(
              globalKey: _showKey2,
              description: 'here you can see your running order if you have any'.tr,
              enabled: isEnabled,
              child: CurrOrderCard(
                order: controller.currOrders.isEmpty ? null : controller.currOrders.last,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // This is the scrollable section
            controller.isLoadingRecent
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SpinKitSquareCircle(color: cs.primary),
                  )
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
