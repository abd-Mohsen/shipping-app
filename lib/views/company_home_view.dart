import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/notifications_controller.dart';
import 'package:shipment/views/tabs/company_explore_tab.dart';
import 'package:shipment/views/tabs/company_home_tab.dart';
import 'package:shipment/views/tabs/company_manage_tab.dart';
import 'package:shipment/views/tabs/company_orders_tab.dart';
import 'package:shipment/views/tabs/company_stats_tab.dart';
import '../constants.dart';
import '../controllers/filter_controller.dart';
import '../controllers/home_navigation_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/my_vehicles_controller.dart';
import '../controllers/theme_controller.dart';
import 'components/my_drawer.dart';
import 'edit_profile_view.dart';

class CompanyHomeView extends StatelessWidget {
  const CompanyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    HomeNavigationController hNC = Get.put(HomeNavigationController());
    FilterController fC = Get.put(FilterController());
    MyVehiclesController mVC = Get.put(MyVehiclesController());
    CompanyHomeController cHC = Get.put(CompanyHomeController(
      homeNavigationController: hNC,
      filterController: fC,
      myVehiclesController: mVC,
    ));
    Get.put(NotificationsController(homeController: cHC));
    LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const CompanyHomeTab(),
      const CompanyOrdersTab(),
      //const CompanyStatsTab(),
      //const CompanyManageTab(), //todo: move to sidebar
      const CompanyExploreTab(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (hNC.tabIndex != 0) {
          hNC.changeTab(0);
        } else
          Get.dialog(kCloseAppDialog());
      },
      child: GetBuilder<HomeNavigationController>(
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              key: cHC.scaffoldKey,
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: FaIcon(FontAwesomeIcons.house),
                    ),
                    label: "home".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: FaIcon(FontAwesomeIcons.list),
                    ),
                    label: "orders".tr,
                  ),
                  // BottomNavigationBarItem(
                  //   icon: const Padding(
                  //     padding: EdgeInsets.all(2.0),
                  //     child: FaIcon(FontAwesomeIcons.chartLine),
                  //   ),
                  //   label: "statistics".tr,
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: const Padding(
                  //     padding: EdgeInsets.all(2.0),
                  //     child: FaIcon(Icons.manage_accounts),
                  //   ),
                  //   label: "manage".tr,
                  // ),
                  BottomNavigationBarItem(
                    icon: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: FaIcon(Icons.search),
                    ),
                    label: "explore".tr,
                  ),
                ],
                showUnselectedLabels: true,
                //height: MediaQuery.of(context).size.height / 11,
                backgroundColor: cs.secondaryContainer, //todo: fix color in dark mode
                selectedItemColor: cs.primary,
                unselectedItemColor: cs.onSurface.withOpacity(0.5),
                iconSize: 18,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                elevation: 0,
                onTap: (i) {
                  controller.changeTab(i);
                  cHC.filterController.clearFilters();
                },
                currentIndex: controller.tabIndex,
              ),
              // appBar: controller.tabIndex == 3
              //     ? AppBar(
              //         backgroundColor: cs.secondaryContainer,
              //         iconTheme: IconThemeData(
              //           color: cs.onSecondaryContainer,
              //         ),
              //         title: GetBuilder<CompanyHomeController>(
              //           builder: (controller) {
              //             return Text(
              //               // controller.isLoadingUser || controller.currentUser == null
              //               //     ? 'company'.toUpperCase()
              //               //     : controller.currentUser!.companyInfo!.name,
              //               "manage".tr,
              //               style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //             );
              //           },
              //         ),
              //         centerTitle: true,
              //         bottom: controller.tabIndex == 3
              //             ? TabBar(
              //                 indicatorColor: cs.primary,
              //                 indicatorWeight: 4,
              //                 tabs: [
              //                   Tab(
              //                     icon: Padding(
              //                       padding: const EdgeInsets.all(4.0),
              //                       child: Icon(
              //                         Icons.local_shipping_outlined,
              //                         color: cs.onSecondaryContainer,
              //                         size: 23,
              //                       ),
              //                     ),
              //                     child: Text(
              //                       "my vehicles".tr,
              //                       style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
              //                       maxLines: 1,
              //                       overflow: TextOverflow.ellipsis,
              //                     ),
              //                   ),
              //                   Tab(
              //                     icon: Padding(
              //                       padding: const EdgeInsets.all(4.0),
              //                       child: Icon(
              //                         Icons.people_alt_outlined,
              //                         color: cs.onSecondaryContainer,
              //                         size: 23,
              //                       ),
              //                     ),
              //                     child: Text(
              //                       "employees".tr,
              //                       style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
              //                       maxLines: 1,
              //                       overflow: TextOverflow.ellipsis,
              //                     ),
              //                   ),
              //                 ],
              //               )
              //             : null,
              //       )
              //     : null,
              backgroundColor: cs.surface,
              //todo: add fade and sidebar arrow
              body: Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (Rect rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white],
                        //set stops as par your requirement
                        stops: [0.92, 1], // 50% transparent, 50% white
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: tabs[controller.tabIndex],
                  ),
                  // arrow to indicate that there is a drawer
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    child: GestureDetector(
                      onTap: () {
                        cHC.scaffoldKey.currentState!.openDrawer();
                      },
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft, // Show left half
                          widthFactor: 0.5, // Clip to 50% width
                          child: CircleAvatar(
                            backgroundColor: cs.primary.withOpacity(0.7),
                            foregroundColor: cs.onPrimary,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(Icons.arrow_forward_ios, size: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              drawer: GetBuilder<CompanyHomeController>(
                builder: (controller) {
                  return MyDrawer(
                    onClose: () {
                      controller.scaffoldKey.currentState!.closeDrawer();
                    },
                    onRefreshUser: () {
                      controller.getCurrentUser();
                    },
                    onEditProfileClick: () {
                      Get.to(EditProfileView(user: controller.currentUser!, homeController: cHC));
                    },
                    onLogout: () {
                      controller.logout();
                    },
                    isLoadingUser: controller.isLoadingUser,
                    currentUser: controller.currentUser,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
