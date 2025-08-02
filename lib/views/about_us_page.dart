import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shipment/controllers/about_us_controller.dart';
import 'package:shipment/views/web_view_page.dart';

import 'components/my_loading_animation.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  ///todo if possible, add url launcher for the phone an email. and add website when ready.
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    AboutUsController aUC = Get.put(AboutUsController());

    alertDialog({required onPressed, required String title, onPressedWhatsApp, Widget? content}) => AlertDialog(
          title: Text(
            title,
            style: tt.titleMedium!.copyWith(color: cs.onSurface),
          ),
          content: content,
          actions: [
            TextButton(
              onPressed: onPressed,
              child: Text(
                "yes".tr,
                style: tt.titleSmall!.copyWith(color: Colors.red),
              ),
            ),
            if (onPressedWhatsApp != null)
              TextButton(
                onPressed: onPressedWhatsApp,
                child: Text(
                  "whatsapp".tr,
                  style: tt.titleSmall!.copyWith(color: Colors.green),
                ),
              ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "no".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        );

    alertDialogWithIcons({required onPressed, required String title, onPressedWhatsApp, Widget? content}) =>
        AlertDialog(
          title: Text(
            title,
            style: tt.titleMedium!.copyWith(color: cs.onSurface),
          ),
          content: content,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: onPressed,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.call, color: cs.onSurface),
                        const SizedBox(height: 4),
                        Text(
                          "phone".tr,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        ),
                      ],
                    ),
                  ),
                  if (onPressedWhatsApp != null)
                    GestureDetector(
                      onTap: onPressedWhatsApp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                          const SizedBox(height: 4),
                          Text(
                            "whatsapp".tr,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                          ),
                        ],
                      ),
                    ),
                  // ListTile(
                  //   onTap: onPressedWhatsApp,
                  //   leading: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  //   title: Text(
                  //     "whatsapp".tr,
                  //     style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  //   ),
                  // ),
                ],
              ),
            ),
            // ListTile(
            //   onTap: onPressed,
            //   leading: Icon(Icons.call, color: cs.onSurface),
            //   title: Text(
            //     "phone".tr,
            //     style: tt.titleSmall!.copyWith(color: cs.onSurface),
            //   ),
            // ),
            //const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "cancel".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        );

    callDialog(String phone, bool whatsapp) => alertDialogWithIcons(
          onPressed: () {
            Get.back();
            aUC.callPhone(
              phone,
              // isCustomer
              //     ? oC.order!.acceptedApplication!.driver.phoneNumber
              //     : oC.order!.orderOwner?.phoneNumber.toString() ?? "order owner is null",
            );
          },
          onPressedWhatsApp: whatsapp
              ? () {
                  Get.back();
                  aUC.openWhatsApp(phone);
                }
              : null,
          title: 'how do you want to call this person?'.tr,
        );

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent, // Add this line
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: cs.surface, // Match your AppBar
        ),
        centerTitle: true,
        title: Text(
          'About app'.tr,
          style: tt.titleMedium!.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetBuilder<AboutUsController>(
        builder: (controller) {
          return controller.isLoading
              ? SpinKitSquareCircle(color: cs.primary)
              : RefreshIndicator(
                  onRefresh: controller.getAboutUsInfo,
                  child: controller.aboutUsInfo == null
                      ? const MyLoadingAnimation()
                      : ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 32, bottom: 24),
                              child: Hero(
                                tag: "logo",
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/images/logo_light.jpg",
                                      height: MediaQuery.sizeOf(context).width / 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Text(
                                "${"this software was developed for".tr} "
                                "${controller.aboutUsInfo!.companyName}, ${"all rights reserved".tr}",
                                style: tt.titleMedium!.copyWith(color: cs.onSurface),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => callDialog(controller.aboutUsInfo!.landline, false),
                                );
                              },
                              leading: Icon(Icons.phone, color: cs.primary),
                              title: Text(
                                controller.aboutUsInfo!.landline,
                                style: tt.titleMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => callDialog(controller.aboutUsInfo!.phone, true),
                                );
                              },
                              leading: Icon(Icons.phone_android, color: cs.primary),
                              title: Text(
                                controller.aboutUsInfo!.phone,
                                style: tt.titleMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                              ),
                            ),
                            // ListTile(
                            //   leading: Icon(Icons.fax, color: cs.primary),
                            //   title: Text(
                            //     "2222222",
                            //     style: tt.titleMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                            //   ),
                            // ),
                            ListTile(
                              onTap: () {
                                controller.launchWebsite();
                              },
                              leading: Icon(Icons.language, color: cs.primary),
                              title: Text(
                                controller.aboutUsInfo!.website,
                                style: tt.titleMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                controller.launchEmail();
                              },
                              leading: Icon(Icons.email, color: cs.primary),
                              title: Text(
                                controller.aboutUsInfo!.email,
                                style: tt.titleMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                              ),
                            ),
                            Divider(
                              color: cs.onSurface.withValues(alpha: 0.5),
                              indent: 75,
                              endIndent: 75,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => WebViewPage(title: "privacy policy".tr, url: "privacy"));
                                  },
                                  child: Text(
                                    "privacy policy".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                  ),
                                ),
                                Text(
                                  " | ".tr,
                                  style: tt.titleMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => WebViewPage(title: "terms and conditions".tr, url: "terms"));
                                  },
                                  child: Text(
                                    "terms and conditions".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                  ),
                                ),
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(right: 12, left: 12, top: 24, bottom: 12),
                            //   child: Text(
                            //     "للاستفسار يرجى التواصل مع المطور",
                            //     style: tt.titleMedium!.copyWith(color: cs.onSurface),
                            //   ),
                            // ),
                            // ListTile(
                            //   leading: Icon(Icons.phone_android, color: cs.primary),
                            //   // title: Text(
                            //   //   "موبايل",
                            //   //   style: tt.titleMedium!.copyWith(color: cs.onSurface),
                            //   // ),
                            //   title: Text(
                            //     "0000000000",
                            //     style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
                            //   ),
                            // ),
                            // ListTile(
                            //   leading: Icon(Icons.email, color: cs.primary),
                            //   // title: Text(
                            //   //   "بريد الكتروني",
                            //   //   style: tt.titleMedium!.copyWith(color: cs.onSurface),
                            //   // ),
                            //   title: Text(
                            //     "example@gmail.com",
                            //     style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
                            //   ),
                            // ),
                          ],
                        ),
                );
        },
      ),
    );
  }
}
