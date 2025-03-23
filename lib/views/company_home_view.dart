import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/tabs/company_employees_tab.dart';
import 'package:shipment/views/tabs/company_orders_tab.dart';
import 'package:shipment/views/tabs/company_stats_tab.dart';
import 'package:shipment/views/tabs/company_vehicles_tab.dart';
import '../constants.dart';
import '../controllers/locale_controller.dart';
import '../controllers/theme_controller.dart';
import 'about_us_page.dart';
import 'edit_profile_view.dart';

class CompanyHomeView extends StatelessWidget {
  const CompanyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    CompanyHomeController cHC = Get.put(CompanyHomeController());
    LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const CompanyVehiclesTab(),
      const CompanyStatsTab(),
      const CompanyOrdersTab(),
      const CompanyEmployeesTab(),
    ];

    //todo: make it tab for orders tab
    return PopScope(
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
                //todo: tab to explore new orders, and tab for curr orders
              ],
              height: MediaQuery.of(context).size.height / 11,
              backgroundColor: Get.isDarkMode ? Color(0xff1e244f) : Color(0xffefefef),
              indicatorColor: cs.primary,
              elevation: 10,
              onDestinationSelected: (i) {
                controller.changeTab(i);
              },
              selectedIndex: controller.tabIndex,
            ),
            appBar: AppBar(
              backgroundColor: cs.primary,
              title: Text(
                'company'.toUpperCase(),
                style: tt.titleLarge!.copyWith(letterSpacing: 2, color: cs.onPrimary),
              ),
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
                                        style: tt.headlineSmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      accountEmail: Text(
                                        con.currentUser!.phoneNumber,
                                        style: tt.titleMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                        }),
                        //todo: add language and other widgets, and unify the drawer if possible
                        //todo: redirect if not verified or have no car
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
                          leading: Icon(
                            Icons.language,
                            color: cs.onSurface,
                          ),
                          title: DropdownButton(
                            elevation: 10,
                            iconEnabledColor: cs.onSurface,
                            dropdownColor: Colors.grey[300],
                            hint: Text(
                              lC.getCurrentLanguageLabel(),
                              style: tt.labelLarge!.copyWith(color: cs.onSurface),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: "ar",
                                child: Text(
                                  "Arabic".tr,
                                  style: tt.labelLarge!.copyWith(color: Colors.black),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "en",
                                child: Text(
                                  "English".tr,
                                  style: tt.labelLarge!.copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              lC.updateLocale(val!);
                            },
                          ),
                        ),
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
    );
  }
}
