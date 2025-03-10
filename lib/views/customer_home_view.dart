import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/locale_controller.dart';
import 'package:shipment/views/components/custom_dropdown.dart';
import 'package:shipment/views/components/order_card.dart';
import 'package:shipment/views/make_order_view.dart';
import 'package:shipment/views/my_addresses_view.dart';
import '../constants.dart';
import '../controllers/theme_controller.dart';
import 'about_us_page.dart';
import 'edit_profile_view.dart';

class CustomerHomeView extends StatelessWidget {
  const CustomerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    CustomerHomeController hC = Get.put(CustomerHomeController());
    LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        Get.dialog(kCloseAppDialog());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cs.primary,
          title: Text(
            'customer'.toUpperCase(),
            style: tt.headlineSmall!.copyWith(letterSpacing: 2, color: cs.onPrimary),
          ),
          centerTitle: true,
          actions: [
            //
          ],
        ),
        backgroundColor: cs.surface,
        body: GetBuilder<CustomerHomeController>(
          //init: HomeController(),
          builder: (controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: CustomDropdown(
                    title: "order type",
                    items: controller.orderTypes,
                    onSelect: (String? type) {
                      controller.setOrderType(type);
                    },
                    selectedValue: controller.selectedOrderType,
                    icon: Icons.filter_list,
                  ),
                ),
                Expanded(
                  child: controller.isLoading
                      ? SpinKitSquareCircle(color: cs.primary)
                      : RefreshIndicator(
                          onRefresh: controller.refreshOrders,
                          child: controller.myOrders.isEmpty
                              ? Center(
                                  child: ListView(
                                    shrinkWrap: true,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset("assets/animations/simple truck.json", height: 200),
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Center(
                                          child: Text(
                                            "no orders, pull down to refresh".tr,
                                            style: tt.titleSmall!.copyWith(
                                              color: cs.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 72),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  itemCount: controller.myOrders.length,
                                  itemBuilder: (context, i) => OrderCard(
                                    order: controller.myOrders[i],
                                    isCustomer: true,
                                  ),
                                ),
                        ),
                ),
              ],
            );
          },
        ),
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
                                        accountName: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${con.currentUser!.firstName} ${con.currentUser!.lastName}",
                                              style: tt.headlineSmall,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            // Text(
                                            //   "@${con.currentUser!.firstName}",
                                            //   style: tt.labelMedium,
                                            //   overflow: TextOverflow.ellipsis,
                                            // ),
                                          ],
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
                      leading: const Icon(Icons.maps_home_work_outlined),
                      title: Text("My Addresses".tr, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
                      onTap: () {
                        Get.to(const MyAddressesView());
                      },
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
      ),
    );
  }
}
