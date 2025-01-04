import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:shipment/controllers/add_address_controller.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';

import '../constants.dart';
import '../controllers/theme_controller.dart';
import 'about_us_page.dart';

class CustomerHomeView extends StatelessWidget {
  const CustomerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    CustomerHomeController hC = Get.put(CustomerHomeController());
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
            style: tt.headlineMedium!.copyWith(letterSpacing: 2, color: cs.onPrimary),
          ),
          centerTitle: true,
          actions: [
            //
          ],
        ),
        backgroundColor: cs.background,
        body: GetBuilder<CustomerHomeController>(
          //init: HomeController(),
          builder: (con) => Column(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              enableDrag: false,
              GetBuilder<AddAddressController>(
                init: AddAddressController(),
                builder: (controller) {
                  return OSMFlutter(
                    controller: controller.mapController,
                    mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                    osmOption: OSMOption(
                      isPicker: true,
                      userLocationMarker: UserLocationMaker(
                        personMarker: MarkerIcon(
                          icon: Icon(Icons.person, color: cs.primary, size: 30),
                        ),
                        directionArrowMarker: MarkerIcon(
                          icon: Icon(Icons.person, color: cs.primary),
                        ),
                      ),
                      zoomOption: ZoomOption(
                        initZoom: 16,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          child: Icon(Icons.add),
          foregroundColor: cs.onPrimary,
        ),
        drawer: Drawer(
          backgroundColor: cs.background,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    GetBuilder<CustomerHomeController>(builder: (con) {
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
                                    style: tt.headlineMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  accountEmail: Text(
                                    con.currentUser!.phoneNumber,
                                    style: tt.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                    }),
                    ListTile(
                      leading: const Icon(Icons.dark_mode_outlined),
                      title: Text("الوضع الداكن", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
                      trailing: Switch(
                        value: tC.switchValue,
                        onChanged: (bool value) {
                          tC.updateTheme(value);
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text("حول التطبيق", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
                      onTap: () {
                        Get.to(const AboutUsPage());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: cs.error),
                      title: Text("تسجيل خروج", style: tt.titleMedium!.copyWith(color: cs.error)),
                      onTap: () {
                        //hC.logout();
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
      ),
    );
  }
}
