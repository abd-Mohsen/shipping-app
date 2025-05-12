import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
import 'package:shipment/controllers/notifications_controller.dart';
import 'package:shipment/views/edit_profile_view.dart';
import 'package:shipment/views/my_vehicles_view.dart';
import 'package:shipment/views/payments_view.dart';
import 'package:shipment/views/tabs/driver_explore_tab.dart';
import 'package:shipment/views/tabs/driver_history_tab.dart';
import 'package:shipment/views/tabs/driver_home_tab.dart';

import '../constants.dart';
import '../controllers/locale_controller.dart';
import '../controllers/theme_controller.dart';
import 'about_us_page.dart';
import 'invoices_view.dart';
import 'notifications_view.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    Get.put(NotificationsController());
    DriverHomeController hC = Get.put(DriverHomeController());
    LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const DriverHistoryTab(),
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
          return Scaffold(
            bottomNavigationBar: NavigationBar(
              destinations: [
                NavigationDestination(icon: Icon(Icons.history), label: "history".tr),
                NavigationDestination(icon: Icon(Icons.home_rounded), label: "home".tr),
                NavigationDestination(icon: Icon(Icons.search), label: "explore".tr),
              ],
              height: MediaQuery.of(context).size.height / 11,
              backgroundColor: Get.isDarkMode ? cs.primary : Color(0xffededed),
              indicatorColor: Get.isDarkMode ? cs.surface : cs.primary,
              elevation: 5,
              onDestinationSelected: (i) {
                controller.changeTab(i);
              },
              selectedIndex: controller.tabIndex,
            ),
            appBar: AppBar(
              backgroundColor: cs.primary,
              iconTheme: IconThemeData(
                color: cs.onPrimary,
              ),
              title: Text(
                'driver'.toUpperCase(), //todo, for employee, write company name
                style: tt.headlineSmall!.copyWith(letterSpacing: 2, color: cs.onPrimary),
              ),
              actions: [
                GetBuilder<NotificationsController>(builder: (controller) {
                  return IconButton(
                    onPressed: () {
                      Get.to(() => const NotificationsView());
                    },
                    icon: Badge(
                      smallSize: 10,
                      backgroundColor: const Color(0xff00ff00),
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.notifications,
                        color: cs.onPrimary,
                      ),
                    ),
                  );
                })
              ],
              centerTitle: true,
            ),
            backgroundColor: cs.surface,
            body: IndexedStack(
              index: controller.tabIndex,
              children: tabs,
            ),
            drawer: Drawer(
              backgroundColor: cs.surface,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        GetBuilder<DriverHomeController>(builder: (con) {
                          return con.isLoadingUser
                              ? Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: SpinKitPianoWave(color: cs.primary),
                                )
                              : con.currentUser == null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          con.getCurrentUser();
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
                                      children: [
                                        UserAccountsDrawerHeader(
                                          //showing old data or not showing at all, add loading (is it solved?)
                                          accountName: Text(
                                            "${con.currentUser!.firstName} ${con.currentUser!.lastName}",
                                            style: tt.headlineSmall,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          accountEmail: Text(
                                            con.currentUser!.phoneNumber,
                                            style: tt.titleMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          currentAccountPicture: hC.isEmployee
                                              ? Text(
                                                  con.currentUser!.companyInfo!.name,
                                                  style: tt.titleMedium,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                )
                                              : null,
                                          currentAccountPictureSize: Size.square(MediaQuery.of(context).size.width / 2),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.manage_accounts),
                                          title: Text("edit profile".tr,
                                              style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                                          onTap: () {
                                            Get.to(EditProfileView(user: con.currentUser!, homeController: hC));
                                          },
                                        ),
                                      ],
                                    );
                        }),
                        ListTile(
                          leading: const Icon(Icons.dark_mode_outlined),
                          title: Text("Dark mode".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                          trailing: Switch(
                            value: tC.switchValue,
                            onChanged: (bool value) {
                              tC.updateTheme(value);
                            },
                          ),
                        ),
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.language,
                        //     color: cs.onSurface,
                        //   ),
                        //   title: DropdownButton(
                        //     elevation: 10,
                        //     iconEnabledColor: cs.onSurface,
                        //     dropdownColor: Colors.grey[300],
                        //     hint: Text(
                        //       lC.getCurrentLanguageLabel(),
                        //       style: tt.labelLarge!.copyWith(color: cs.onSurface),
                        //     ),
                        //     items: [
                        //       DropdownMenuItem(
                        //         value: "ar",
                        //         child: Text(
                        //           "Arabic".tr,
                        //           style: tt.labelLarge!.copyWith(color: Colors.black),
                        //         ),
                        //       ),
                        //       DropdownMenuItem(
                        //         value: "en",
                        //         child: Text(
                        //           "English".tr,
                        //           style: tt.labelLarge!.copyWith(color: Colors.black),
                        //         ),
                        //       ),
                        //     ],
                        //     onChanged: (val) {
                        //       lC.updateLocale(val!);
                        //     },
                        //   ),
                        // ),
                        Visibility(
                          visible: !hC.isEmployee,
                          child: ListTile(
                            leading: const Icon(Icons.local_shipping_outlined),
                            title: Text("my vehicles".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                            onTap: () {
                              Get.to(() => const MyVehiclesView());
                            },
                          ),
                        ),
                        Visibility(
                          visible: !hC.isEmployee,
                          child: ListTile(
                            leading: const Icon(Icons.monetization_on_outlined),
                            title: Text("payment methods".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                            onTap: () {
                              Get.to(() => const PaymentsView());
                            },
                          ),
                        ),
                        GetBuilder<DriverHomeController>(builder: (con) {
                          return Visibility(
                            visible: con.currentUser != null && !con.isEmployee,
                            child: ListTile(
                              leading: const Icon(Icons.text_snippet),
                              title: Text("payment history".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                              onTap: () {
                                Get.to(() => InvoicesView(user: con.currentUser!));
                              },
                            ),
                          );
                        }),

                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: Text("About app".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                          onTap: () {
                            Get.to(const AboutUsPage());
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout, color: cs.error),
                          title: Text("logout".tr, style: tt.titleSmall!.copyWith(color: cs.error)),
                          onTap: () {
                            hC.logout();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      '® جميع الحقوق محفوظة',
                      style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
