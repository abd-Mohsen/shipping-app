import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/locale_controller.dart';
import 'package:shipment/views/invoices_view.dart';
import 'package:shipment/views/make_order_view.dart';
import 'package:shipment/views/my_addresses_view.dart';
import 'package:shipment/views/payments_view.dart';
import 'package:shipment/views/tabs/customer_home_tab.dart';
import 'package:shipment/views/tabs/customer_orders_tab.dart';
import '../constants.dart';
import '../controllers/home_navigation_controller.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/theme_controller.dart';
import 'about_us_page.dart';
import 'edit_profile_view.dart';

class CustomerHomeView extends StatelessWidget {
  const CustomerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    HomeNavigationController hNC = Get.put(HomeNavigationController());
    CustomerHomeController hC = Get.put(CustomerHomeController(homeNavigationController: hNC));
    Get.put(NotificationsController());
    LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const CustomerOrdersTab(),
      const CustomerHomeTab(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        Get.dialog(kCloseAppDialog());
      },
      child: SafeArea(
        child: GetBuilder<HomeNavigationController>(builder: (controller) {
          return Scaffold(
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
            key: hC.scaffoldKey,
            backgroundColor: cs.surface,
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
            body: tabs[controller.tabIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(() => const MakeOrderView());
              },
              foregroundColor: cs.onPrimary,
              child: Icon(Icons.add, color: cs.onPrimary),
            ),
            drawer: Drawer(
              backgroundColor: cs.surface,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        GetBuilder<CustomerHomeController>(
                          builder: (con) {
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
                                            'refresh'.tr,
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
                          },
                        ),
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
                        ListTile(
                          leading: const Icon(Icons.maps_home_work_outlined),
                          title: Text("My Addresses".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                          onTap: () {
                            Get.to(const MyAddressesView());
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.monetization_on_outlined),
                          title: Text("payment methods".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                          onTap: () {
                            Get.to(() => const PaymentsView());
                          },
                        ),
                        GetBuilder<CustomerHomeController>(builder: (con) {
                          return Visibility(
                            visible: con.currentUser != null,
                            child: ListTile(
                              leading: const Icon(Icons.text_snippet),
                              title: Text("payment history".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                              onTap: () {
                                Get.to(() => InvoicesView(user: hC.currentUser!));
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
                      "${"all rights reserved".tr} ®",
                      style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
