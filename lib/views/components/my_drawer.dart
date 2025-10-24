import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/send_report_controller.dart';
import 'package:shipment/models/user_model.dart';
import 'package:shipment/views/components/send_report_sheet.dart';
import 'package:shipment/views/components/share_app_sheet.dart';
import 'package:shipment/views/faq_page.dart';
import 'package:shipment/views/payment_methods_view.dart';
import '../../controllers/locale_controller.dart';
import '../../controllers/theme_controller.dart';
import '../about_us_page.dart';
import '../invoices_view.dart';
import '../my_addresses_view.dart';
import '../my_vehicles_view.dart';
import '../tabs/company_manage_tab.dart';
import '../tabs/company_stats_tab.dart';
import 'drawer_card.dart';

class MyDrawer extends StatelessWidget {
  final void Function() onClose;
  final void Function() onRefreshUser;
  final void Function() onEditProfileClick;
  final void Function() onLogout;
  final bool isLoadingUser;
  final UserModel? currentUser;

  const MyDrawer({
    super.key,
    required this.onClose,
    required this.onRefreshUser,
    required this.onEditProfileClick,
    required this.onLogout,
    required this.isLoadingUser,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    ThemeController tC = Get.find();
    LocaleController lC = Get.find();

    final getStorage = GetStorage();
    String role = getStorage.read("role");

    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: cs.secondaryContainer,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4, left: 16, right: 16),
                          child: GestureDetector(
                            onTap: onClose,
                            child: Icon(
                              Icons.arrow_back,
                              color: cs.onSurface,
                              weight: 2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: FaIcon(tC.switchValue ? Icons.sunny : FontAwesomeIcons.solidMoon),
                            onPressed: () {
                              tC.updateTheme(!tC.switchValue);
                            },
                          ),
                        ),
                      ],
                    ),
                    isLoadingUser
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: SpinKitPianoWave(color: cs.primary),
                          )
                        : currentUser == null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: ElevatedButton(
                                  onPressed: onRefreshUser,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                                  ),
                                  child: Text(
                                    'error, click to refresh'.tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  InkWell(
                                    onTap: onEditProfileClick,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentUser!.role.type.tr,
                                              style:
                                                  tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.person_outline, color: cs.primary, size: 40),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "${currentUser!.firstName} ${currentUser!.lastName}",
                                                    style: tt.titleMedium!.copyWith(
                                                      color: cs.onSecondaryContainer,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: cs.primary,
                                                  size: 14,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              currentUser!.phoneNumber,
                                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (role == "company" || role == "company_employee")
                                              Column(
                                                children: [
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    currentUser!.companyInfo?.name ?? "",
                                                    style: tt.labelLarge!.copyWith(color: cs.onSurface),
                                                  ),
                                                ],
                                              ),
                                            // const SizedBox(height: 4),
                                            // Text(
                                            //   "دمشق, ركن الدين, صلاح الدين",
                                            //   style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.4)),
                                            //   overflow: TextOverflow.ellipsis,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: cs.onSurface.withValues(alpha: 0.2),
                                  )
                                ],
                              ),
                  ],
                ),

                ListTile(
                  leading: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(100),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: cs.surface,
                      foregroundColor: cs.primary,
                      child: Icon(Icons.language, size: 22, color: cs.primary),
                    ),
                  ),
                  title: DropdownButton(
                    elevation: 10,
                    iconEnabledColor: cs.onSurface,
                    dropdownColor: Colors.grey[300],
                    hint: Text(
                      lC.getCurrentLanguageLabel(),
                      style: tt.labelMedium!.copyWith(color: cs.onSurface),
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
                const SizedBox(height: 4),
                Visibility(
                  visible: role == "customer",
                  child: DrawerCard(
                    title: "My Addresses".tr,
                    icon: Icons.maps_home_work_outlined,
                    onTap: () {
                      Get.to(() => const MyAddressesView());
                    },
                  ),
                ),
                if (currentUser != null && ["company_employee", "driver"].contains(role))
                  DrawerCard(
                    title: "my vehicles".tr,
                    icon: Icons.local_shipping_outlined,
                    isMarked: ["refused", "No_Input"].contains(currentUser!.driverInfo?.vehicleStatus),
                    onTap: () {
                      Get.to(() => const MyVehiclesView());
                    },
                  ),

                Visibility(
                  visible: role != "company_employee",
                  child: DrawerCard(
                    title: "payment methods".tr,
                    icon: Icons.monetization_on_outlined,
                    onTap: () {
                      //Get.to(const PaymentsView());
                      Get.to(() => const PaymentMethodsView());
                    },
                  ),
                ),
                Visibility(
                  visible: role == "company",
                  child: DrawerCard(
                    title: "manage".tr,
                    icon: Icons.manage_accounts_outlined,
                    onTap: () {
                      //Get.to(const PaymentsView());
                      Get.to(
                        const CompanyManageTab(),
                      );
                    },
                  ),
                ),

                // BottomNavigationBarItem(
                //   icon: const Padding(
                //     padding: EdgeInsets.all(2.0),
                //     child: FaIcon(FontAwesomeIcons.chartLine),
                //   ),
                //   label: "statistics".tr,
                // ),
                Visibility(
                  visible: role == "company",
                  child: DrawerCard(
                    title: "statistics".tr,
                    icon: FontAwesomeIcons.chartLine,
                    onTap: () {
                      //Get.to(const PaymentsView());
                      Get.to(() => const CompanyStatsTab());
                    },
                  ),
                ),
                Visibility(
                  visible: currentUser != null && role != "company_employee",
                  child: DrawerCard(
                    title: "payment history".tr,
                    icon: Icons.text_snippet_outlined,
                    onTap: () {
                      Get.to(() => const InvoicesView());
                    },
                  ),
                ),

                DrawerCard(
                  title: "About app".tr,
                  icon: Icons.info_outline,
                  onTap: () {
                    Get.to(() => const AboutUsPage());
                  },
                ),
                DrawerCard(
                  title: "send a report".tr,
                  icon: Icons.message_outlined,
                  onTap: () {
                    showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withValues(alpha: 0.5),
                      enableDrag: false,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: const SendReportSheet(),
                      ),
                    ).then(
                      (_) => Get.delete<SendReportController>(),
                    );
                  },
                ),
                DrawerCard(
                  title: "FAQs".tr,
                  icon: Icons.question_mark,
                  onTap: () {
                    Get.to(() => const FaqPage());
                  },
                ),
                DrawerCard(
                  title: "share this app".tr,
                  icon: Icons.share,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: cs.surface,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) {
                        return const ShareAppSheet();
                      },
                    );
                  },
                ),
                DrawerCard(
                  title: "logout".tr,
                  icon: Icons.logout_outlined,
                  textColor: cs.error,
                  trailing: const SizedBox.shrink(),
                  onTap: onLogout,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "${"all rights reserved".tr} ®",
              style: tt.labelSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
