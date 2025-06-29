import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/filter_controller.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
import 'package:shipment/controllers/notifications_controller.dart';
import 'package:shipment/views/edit_profile_view.dart';
import 'package:shipment/views/tabs/explore_orders_tab.dart';
import 'package:shipment/views/tabs/driver_home_tab.dart';
import 'package:shipment/views/tabs/my_orders_tab.dart';
import '../constants.dart';
import '../controllers/current_user_controller.dart';
import '../controllers/online_socket_controller.dart';
import '../controllers/refresh_socket_controller.dart';
import '../controllers/shared_home_controller.dart';
import 'components/my_bottom_bar.dart';
import 'components/my_drawer.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeNavigationController hNC = Get.find();
    //FilterController fC = Get.put(FilterController());
    CurrentUserController cUC = Get.find();

    // DriverHomeController hC = Get.put(DriverHomeController());
    SharedHomeController sHC = Get.find();
    // Get.put(NotificationsController());
    // Get.put(OnlineSocketController());
    // Get.put(RefreshSocketController());

    ColorScheme cs = Theme.of(context).colorScheme;
    //TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const DriverHomeTab(),
      const MyOrdersTab(),
      const ExploreOrdersTab(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (hNC.tabIndex != 0) {
          hNC.changeTab(0);
        } else
          Get.dialog(kCloseAppDialog());
      },
      child: GetBuilder<HomeNavigationController>(
        init: HomeNavigationController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              key: cUC.scaffoldKey,
              // bottomNavigationBar: NavigationBar(
              //   destinations: [
              //     NavigationDestination(icon: Icon(Icons.history), label: "history".tr),
              //     NavigationDestination(icon: Icon(Icons.home_rounded), label: "home".tr),
              //     NavigationDestination(icon: Icon(Icons.search), label: "explore".tr),
              //   ],
              //   height: MediaQuery.of(context).size.height / 11,
              //   backgroundColor: Get.isDarkMode ? cs.primary : Color(0xffededed),
              //   indicatorColor: Get.isDarkMode ? cs.surface : cs.primary,
              //   elevation: 5,
              //   onDestinationSelected: (i) {
              //     controller.changeTab(i);
              //   },
              //   selectedIndex: controller.tabIndex,
              // ),

              bottomNavigationBar: MyBottomBar(
                onChanged: (i) {
                  controller.changeTab(i);
                  sHC.filterController.clearFilters();
                },
                currentIndex: controller.tabIndex,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height / 13.5,
              //   child: BottomNavigationBar(
              //     items: [
              //       BottomNavigationBarItem(
              //         icon: const Padding(
              //           padding: EdgeInsets.all(2.0),
              //           child: FaIcon(FontAwesomeIcons.house),
              //         ),
              //         label: "home".tr,
              //       ),
              //       BottomNavigationBarItem(
              //         icon: const Padding(
              //           padding: EdgeInsets.all(2.0),
              //           child: FaIcon(FontAwesomeIcons.list),
              //         ),
              //         label: "orders".tr,
              //       ),
              //       BottomNavigationBarItem(
              //         icon: const Padding(
              //           padding: EdgeInsets.all(2.0),
              //           child: FaIcon(Icons.search),
              //         ),
              //         label: "explore".tr,
              //       ),
              //     ],
              //     //height: MediaQuery.of(context).size.height / 11,
              //     backgroundColor: cs.secondaryContainer,
              //     selectedItemColor: cs.primary,
              //     unselectedItemColor: cs.onSurface.withValues(alpha: 0.5),
              //     iconSize: 18,
              //     selectedFontSize: 10,
              //     unselectedFontSize: 10,
              //     elevation: 0,
              //     onTap: (i) {
              //       controller.changeTab(i);
              //       sHC.filterController.clearFilters();
              //     },
              //     currentIndex: controller.tabIndex,
              //   ),
              // ),
              //-----------------------------
              // appBar: AppBar(
              //   backgroundColor: cs.primary,
              //   iconTheme: IconThemeData(
              //     color: cs.onPrimary,
              //   ),
              //   title: Text(
              //     'driver'.toUpperCase(),
              //     style: tt.headlineSmall!.copyWith(letterSpacing: 2, color: cs.onPrimary),
              //   ),
              //   actions: [
              //     GetBuilder<NotificationsController>(builder: (controller) {
              //       return IconButton(
              //         onPressed: () {
              //           Get.to(() => const NotificationsView());
              //         },
              //         icon: Badge(
              //           smallSize: 10,
              //           backgroundColor: const Color(0xff00ff00),
              //           alignment: Alignment.topRight,
              //           child: Icon(
              //             Icons.notifications,
              //             color: cs.onPrimary,
              //           ),
              //         ),
              //       );
              //     })
              //   ],
              //   centerTitle: true,
              // ),
              backgroundColor: cs.surface,
              // body: IndexedStack(
              //   index: controller.tabIndex,
              //   children: tabs,
              // ),
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
                        cUC.scaffoldKey.currentState!.openDrawer();
                      },
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft, // Show left half
                          widthFactor: 0.5, // Clip to 50% width
                          child: CircleAvatar(
                            backgroundColor: cs.primary.withValues(alpha: 0.7),
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
              drawer: GetBuilder<CurrentUserController>(
                builder: (controller) {
                  return MyDrawer(
                    onClose: () {
                      controller.scaffoldKey.currentState!.closeDrawer();
                    },
                    onRefreshUser: () {
                      controller.getCurrentUser();
                    },
                    onEditProfileClick: () {
                      Get.to(EditProfileView());
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
