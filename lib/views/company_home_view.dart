import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/notifications_controller.dart';
import 'package:shipment/views/notifications_view.dart';
import 'package:shipment/views/payments_view.dart';
import 'package:shipment/views/tabs/company_employees_tab.dart';
import 'package:shipment/views/tabs/company_orders_tab.dart';
import 'package:shipment/views/tabs/company_stats_tab.dart';
import 'package:shipment/views/tabs/company_vehicles_tab.dart';
import '../constants.dart';
import '../controllers/filter_controller.dart';
import '../controllers/home_navigation_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/theme_controller.dart';
import 'about_us_page.dart';
import 'edit_profile_view.dart';
import 'invoices_view.dart';

class CompanyHomeView extends StatelessWidget {
  const CompanyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    Get.put(NotificationsController());
    HomeNavigationController hNC = Get.put(HomeNavigationController());
    FilterController fC = Get.put(FilterController());
    CompanyHomeController cHC = Get.put(CompanyHomeController(
      homeNavigationController: hNC,
      filterController: fC,
    ));
    LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const CompanyVehiclesTab(),
      const CompanyStatsTab(),
      const CompanyOrdersTab(),
      const CompanyEmployeesTab(),
    ];

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          Get.dialog(kCloseAppDialog());
        },
        child: GetBuilder<CompanyHomeController>(
          builder: (controller) {
            return Scaffold(
              bottomNavigationBar: NavigationBar(
                destinations: [
                  NavigationDestination(icon: Icon(Icons.directions_car), label: "vehicles".tr),
                  NavigationDestination(icon: Icon(Icons.home_rounded), label: "home".tr),
                  NavigationDestination(icon: Icon(Icons.list), label: "orders".tr),
                  NavigationDestination(icon: Icon(Icons.manage_accounts), label: "employees".tr),
                ],
                height: MediaQuery.of(context).size.height / 11,
                backgroundColor: Get.isDarkMode ? cs.primary : Color(0xffefefef),
                indicatorColor: Get.isDarkMode ? cs.surface : cs.primary,
                elevation: 10,
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
                title: GetBuilder<CompanyHomeController>(
                  builder: (controller) {
                    return Text(
                      controller.isLoadingUser || controller.currentUser == null
                          ? 'company'.toUpperCase()
                          : controller.currentUser!.companyInfo!.name,
                      style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                centerTitle: true,
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
                bottom: controller.tabIndex == 2
                    ? TabBar(
                        indicatorColor: Color(0xff7fff00),
                        indicatorWeight: 4,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.history,
                              color: cs.onPrimary,
                              size: 25,
                            ),
                            child: Text(
                              "history".tr,
                              style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.checklist_outlined,
                              color: cs.onPrimary,
                              size: 25,
                            ),
                            child: Text(
                              "current".tr,
                              style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.search,
                              color: cs.onPrimary,
                              size: 25,
                            ),
                            child: Text(
                              "explore".tr,
                              style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : null,
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
                          GetBuilder<CompanyHomeController>(builder: (con) {
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
                                    : UserAccountsDrawerHeader(
                                        //showing old data or not showing at all, add loading (is it solved?)
                                        accountName: Text(
                                          "${con.currentUser!.firstName} ${con.currentUser!.lastName}",
                                          style: tt.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        accountEmail: Text(
                                          con.currentUser!.phoneNumber,
                                          style: tt.titleMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                          }),
                          ListTile(
                            leading: const Icon(Icons.manage_accounts),
                            title: Text("edit profile".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                            onTap: () {
                              Get.to(EditProfileView(user: controller.currentUser!, homeController: cHC));
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
                          ListTile(
                            leading: const Icon(Icons.monetization_on_outlined),
                            title: Text("payment methods".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                            onTap: () {
                              Get.to(() => const PaymentsView());
                            },
                          ),
                          GetBuilder<CompanyHomeController>(builder: (con) {
                            return Visibility(
                              visible: con.currentUser != null,
                              child: ListTile(
                                leading: const Icon(Icons.text_snippet),
                                title: Text("payment history".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                                onTap: () {
                                  Get.to(() => InvoicesView(user: con.currentUser!));
                                },
                              ),
                            );
                          }),
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
                              cHC.logout();
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
      ),
    );
  }
}
