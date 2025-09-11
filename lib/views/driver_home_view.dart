import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
import 'package:shipment/views/edit_profile_view.dart';
import 'package:shipment/views/tabs/my_orders_tab.dart';
import 'package:shipment/views/tabs/new_driver_tab.dart';
import '../constants.dart';
import '../controllers/current_user_controller.dart';
import '../controllers/shared_home_controller.dart';
import 'components/my_bottom_bar.dart';
import 'components/my_drawer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
      const NewDriverTab(),
      const MyOrdersTab(),
      //const ExploreOrdersTab(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (hNC.tabIndex != 0) {
          hNC.changeTab(0);
        } else {
          Get.dialog(kCloseAppDialog());
        }
      },
      child: GetBuilder<HomeNavigationController>(
        init: HomeNavigationController(),
        builder: (controller) {
          return Scaffold(
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
            body: GetBuilder<CurrentUserController>(
              builder: (innerController) {
                return ModalProgressHUD(
                  inAsyncCall: innerController.isLoadingUser,
                  blur: 4, // optional blur behind the indicator
                  progressIndicator: const CircularProgressIndicator(),
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white],
                            //set stops as par your requirement
                            stops: [0.97, 1], // 50% transparent, 50% white
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: IndexedStack(
                          index: controller.tabIndex,
                          children: tabs,
                        ),
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
                              alignment: Directionality.of(context) == TextDirection.rtl
                                  ? Alignment.centerLeft // Clip to right half for RTL
                                  : Alignment.centerRight, // Clip to left half for LTR
                              widthFactor: 0.5,
                              child: CircleAvatar(
                                backgroundColor: cs.primary.withValues(alpha: 0.7),
                                foregroundColor: cs.onPrimary,
                                child: Padding(
                                  padding: Directionality.of(context) == TextDirection.rtl
                                      ? const EdgeInsets.only(right: 16)
                                      : const EdgeInsets.only(left: 16),
                                  child: const Icon(Icons.arrow_forward_ios, size: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
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
                    Get.to(() => const EditProfileView());
                  },
                  onLogout: () {
                    controller.logout();
                  },
                  isLoadingUser: controller.isLoadingUser,
                  currentUser: controller.currentUser,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
