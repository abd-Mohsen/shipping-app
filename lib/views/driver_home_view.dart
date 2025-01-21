import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/driver_home_controller.dart';

import '../constants.dart';
import '../controllers/theme_controller.dart';
import 'about_us_page.dart';

class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    DriverHomeController hC = Get.put(DriverHomeController());
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
            'driver'.toUpperCase(),
            style: tt.headlineMedium!.copyWith(letterSpacing: 2, color: cs.onPrimary),
          ),
          centerTitle: true,
          actions: [
            //
          ],
        ),
        backgroundColor: cs.background,
        body: GetBuilder<DriverHomeController>(
          //init: HomeController(),
          builder: (con) => Column(),
        ),
        drawer: Drawer(
          backgroundColor: cs.background,
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
                              : UserAccountsDrawerHeader(
                                  //showing old data or not showing at all, add loading (is it solved?)
                                  accountName: Text(
                                    "${con.currentUser!.firstName} ${con.currentUser!.lastName}",
                                    //todo: handle arabic UTF-8, preferably from api.dart directly
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
      ),
    );
  }
}
