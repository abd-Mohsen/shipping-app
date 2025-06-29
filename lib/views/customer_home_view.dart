import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/refresh_socket_controller.dart';
import 'package:shipment/controllers/shared_home_controller.dart';
import 'package:shipment/views/components/my_drawer.dart';
import 'package:shipment/views/make_order_view.dart';
import 'package:shipment/views/tabs/customer_home_tab.dart';
import 'package:shipment/views/tabs/my_orders_tab.dart';
import '../constants.dart';
import '../controllers/current_user_controller.dart';
import '../controllers/filter_controller.dart';
import '../controllers/home_navigation_controller.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/online_socket_controller.dart';
import 'edit_profile_view.dart';

class CustomerHomeView extends StatelessWidget {
  const CustomerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    //ThemeController tC = Get.find();
    // Get.put(NotificationsController());
    // Get.put(OnlineSocketController());
    // Get.put(RefreshSocketController());

    HomeNavigationController hNC = Get.find();
    //FilterController fC = Get.put(FilterController());
    CurrentUserController cUC = Get.find();

    //CustomerHomeController hC = Get.put(CustomerHomeController());
    SharedHomeController sHC = Get.find();

    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const CustomerHomeTab(),
      const MyOrdersTab(),
    ];

    List<IconData> iconsList = [Icons.home, Icons.list];
    List<String> titlesList = ["home".tr, "orders".tr];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (hNC.tabIndex != 0) {
          hNC.changeTab(0);
        } else
          Get.dialog(kCloseAppDialog());
      },
      child: SafeArea(
        child: GetBuilder<HomeNavigationController>(
          builder: (controller) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              // appBar: AppBar(
              //   backgroundColor: cs.primary,
              //   iconTheme: IconThemeData(
              //     color: cs.onPrimary,
              //   ),
              //   title: Text(
              //     'my orders'.tr,
              //     style: tt.titleMedium!.copyWith(letterSpacing: 2, color: cs.onPrimary),
              //   ),
              //   centerTitle: true,
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
              // ),
              key: cUC.scaffoldKey,
              backgroundColor: cs.surface,
              // bottomNavigationBar: SizedBox(
              //   height: MediaQuery.of(context).size.height / 14,
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
              //       hC.filterController.clearFilters();
              //     },
              //     currentIndex: controller.tabIndex,
              //   ),
              // ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              //todo: use this bottom bar in company and driver
              bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                backgroundColor: cs.secondaryContainer,
                splashRadius: 0,
                itemCount: iconsList.length,
                tabBuilder: (int i, bool isActive) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconsList[i],
                        size: 24,
                        color: isActive ? cs.primary : cs.onSecondaryContainer.withValues(alpha: 0.7),
                      ),
                      Text(
                        titlesList[i],
                        style: tt.labelSmall!.copyWith(
                          color: isActive ? cs.primary : cs.onSecondaryContainer.withValues(alpha: 0.7),
                        ),
                      )
                    ],
                  );
                },
                elevation: 0,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.defaultEdge,
                gapWidth: 0,
                notchMargin: 0,
                leftCornerRadius: 0,
                rightCornerRadius: 0,
                onTap: (i) {
                  controller.changeTab(i);
                  sHC.filterController.clearFilters();
                },
                activeIndex: controller.tabIndex,
              ),
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
              // Stack(
              //   children: [
              //     // Main content behind the blur
              //     tabs[controller.tabIndex],
              //
              //     // Positioned blur effect above bottom nav bar
              //     Positioned(
              //       bottom: 0, // height of bottom nav bar
              //       left: 0,
              //       right: 0,
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16),
              //         child: ClipRect(
              //           child: BackdropFilter(
              //             filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              //             child: Container(
              //               height: 20,
              //               color: Colors.white.withOpacity(0.005), // semi-transparent
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              floatingActionButton: FloatingActionButton(
                elevation: 10,
                onPressed: () {
                  Get.to(() => const MakeOrderView(edit: false));
                },
                foregroundColor: cs.onPrimary,
                shape: const CircleBorder(),
                child: Icon(Icons.add, color: cs.onPrimary),
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
            );
          },
        ),
      ),
    );
  }
}

// old drawer
//
// Drawer(
//   shape: RoundedRectangleBorder(
//     borderRadius: BorderRadius.circular(0),
//   ),
//   backgroundColor: cs.secondaryContainer,
//   child: Column(
//     children: [
//       Expanded(
//         child: ListView(
//           children: [
//             Material(
//               elevation: 1,
//               color: cs.secondaryContainer,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 12, bottom: 4, left: 16, right: 16),
//                         child: GestureDetector(
//                           onTap: () {
//                             hC.scaffoldKey.currentState!.closeDrawer();
//                           },
//                           child: Icon(
//                             Icons.arrow_back,
//                             color: cs.onSurface,
//                             weight: 2,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: IconButton(
//                           icon: FaIcon(tC.switchValue ? Icons.sunny : FontAwesomeIcons.solidMoon),
//                           onPressed: () {
//                             tC.updateTheme(!tC.switchValue);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   GetBuilder<CustomerHomeController>(
//                     builder: (con) {
//                       return con.isLoadingUser
//                           ? Padding(
//                               padding: const EdgeInsets.all(24),
//                               child: SpinKitPianoWave(color: cs.primary),
//                             )
//                           : con.currentUser == null
//                               ? Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       con.getCurrentUser();
//                                     },
//                                     style: ButtonStyle(
//                                       backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
//                                     ),
//                                     child: Text(
//                                       'refresh'.tr,
//                                       style: tt.titleMedium!.copyWith(color: cs.onPrimary),
//                                     ),
//                                   ),
//                                 )
//                               : Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Get.to(
//                                               EditProfileView(user: con.currentUser!, homeController: hC));
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 con.currentUser!.role.type.tr,
//                                                 style: tt.titleSmall!
//                                                     .copyWith(color: cs.onSurface.withOpacity(0.4)),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                               SizedBox(height: 8),
//                                               Row(
//                                                 children: [
//                                                   Icon(Icons.person, color: cs.primary, size: 40),
//                                                   SizedBox(width: 8),
//                                                   Expanded(
//                                                     child: Text(
//                                                       "${con.currentUser!.firstName} ${con.currentUser!.lastName}",
//                                                       style: tt.titleMedium!.copyWith(
//                                                         color: cs.onSecondaryContainer,
//                                                         fontWeight: FontWeight.bold,
//                                                       ),
//                                                       overflow: TextOverflow.ellipsis,
//                                                       maxLines: 2,
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 16),
//                                                   Icon(
//                                                     Icons.arrow_forward_ios,
//                                                     color: cs.primary,
//                                                     size: 14,
//                                                   )
//                                                 ],
//                                               ),
//                                               SizedBox(height: 8),
//                                               Text(
//                                                 con.currentUser!.phoneNumber,
//                                                 style: tt.titleSmall!.copyWith(color: cs.primary),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                               Text(
//                                                 "دمشق, ركن الدين, صلاح الدين",
//                                                 style: tt.labelSmall!
//                                                     .copyWith(color: cs.onSurface.withOpacity(0.4)),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     // Divider(
//                                     //   thickness: 1,
//                                     //   color: cs.onSurface.withOpacity(0.2),
//                                     // )
//                                   ],
//                                 );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//             // ListTile(
//             //   leading: Icon(
//             //     Icons.language,
//             //     color: cs.onSurface,
//             //   ),
//             //   title: DropdownButton(
//             //     elevation: 10,
//             //     iconEnabledColor: cs.onSurface,
//             //     dropdownColor: Colors.grey[300],
//             //     hint: Text(
//             //       lC.getCurrentLanguageLabel(),
//             //       style: tt.labelLarge!.copyWith(color: cs.onSurface),
//             //     ),
//             //     items: [
//             //       DropdownMenuItem(
//             //         value: "ar",
//             //         child: Text(
//             //           "Arabic".tr,
//             //           style: tt.labelLarge!.copyWith(color: Colors.black),
//             //         ),
//             //       ),
//             //       DropdownMenuItem(
//             //         value: "en",
//             //         child: Text(
//             //           "English".tr,
//             //           style: tt.labelLarge!.copyWith(color: Colors.black),
//             //         ),
//             //       ),
//             //     ],
//             //     onChanged: (val) {
//             //       lC.updateLocale(val!);
//             //     },
//             //   ),
//             // ),
//             DrawerCard(
//               title: "My Addresses".tr,
//               icon: Icons.maps_home_work_outlined,
//               onTap: () {
//                 Get.to(const MyAddressesView());
//               },
//             ),
//             DrawerCard(
//               title: "payment methods".tr,
//               icon: Icons.monetization_on_outlined,
//               onTap: () {
//                 Get.to(const PaymentsView());
//               },
//             ),
//             GetBuilder<CustomerHomeController>(
//               builder: (con) {
//                 return Visibility(
//                   visible: con.currentUser != null,
//                   child: DrawerCard(
//                     title: "payment history".tr,
//                     icon: Icons.text_snippet_outlined,
//                     onTap: () {
//                       Get.to(InvoicesView(user: hC.currentUser!));
//                     },
//                   ),
//                 );
//               },
//             ),
//             DrawerCard(
//               title: "About app".tr,
//               icon: Icons.info_outline,
//               onTap: () {
//                 Get.to(const AboutUsPage());
//               },
//             ),
//             DrawerCard(
//               title: "logout".tr,
//               icon: Icons.logout_outlined,
//               textColor: cs.error,
//               trailing: SizedBox.shrink(),
//               onTap: () {
//                 hC.logout();
//               },
//             ),
//           ],
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0),
//         child: Text(
//           "${"all rights reserved".tr} ®",
//           style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.6)),
//         ),
//       ),
//     ],
//   ),
// ),
