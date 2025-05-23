import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
import 'package:shipment/controllers/notifications_controller.dart';
import 'package:shipment/views/edit_profile_view.dart';
import 'package:shipment/views/tabs/driver_explore_tab.dart';
import 'package:shipment/views/tabs/driver_orders_tab.dart';
import 'package:shipment/views/tabs/driver_home_tab.dart';
import '../constants.dart';
import 'components/my_drawer.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationsController());
    HomeNavigationController hNC = Get.put(HomeNavigationController());
    DriverHomeController hC = Get.put(DriverHomeController(homeNavigationController: hNC));
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const DriverOrdersTab(),
      const DriverHomeTab(),
      const DriverExploreTab(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        Get.dialog(kCloseAppDialog());
      },
      child: GetBuilder<HomeNavigationController>(
        init: HomeNavigationController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
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

              bottomNavigationBar: SizedBox(
                height: MediaQuery.of(context).size.height / 14,
                child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FaIcon(FontAwesomeIcons.list),
                      ),
                      label: "orders".tr,
                    ),
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
                        child: FaIcon(Icons.search),
                      ),
                      label: "explore".tr,
                    ),
                  ],
                  //height: MediaQuery.of(context).size.height / 11,
                  backgroundColor: cs.secondaryContainer,
                  selectedItemColor: cs.primary,
                  unselectedItemColor: cs.onSurface.withOpacity(0.5),
                  iconSize: 18,
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                  elevation: 0,
                  onTap: (i) {
                    controller.changeTab(i);
                  },
                  currentIndex: controller.tabIndex,
                ),
              ),
              // appBar: AppBar(
              //   backgroundColor: cs.primary,
              //   iconTheme: IconThemeData(
              //     color: cs.onPrimary,
              //   ),
              //   title: Text(
              //     'driver'.toUpperCase(), //todo, for employee, write company name
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
                ],
              ),
              drawer: GetBuilder<DriverHomeController>(
                builder: (controller) {
                  return MyDrawer(
                    onClose: () {
                      hC.scaffoldKey.currentState!.closeDrawer();
                    },
                    onRefreshUser: () {
                      hC.getCurrentUser();
                    },
                    onEditProfileClick: () {
                      Get.to(EditProfileView(user: hC.currentUser!, homeController: hC));
                    },
                    onLogout: () {
                      hC.logout();
                    },
                    isLoadingUser: hC.isLoadingUser,
                    currentUser: hC.currentUser,
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
