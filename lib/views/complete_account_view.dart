import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/complete_account_controller.dart';
import 'package:shipment/models/user_model.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/id_image_selector.dart';

class CompleteAccountView extends StatelessWidget {
  final UserModel user;
  const CompleteAccountView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    CompleteAccountController cAC = Get.put(CompleteAccountController(user: user));

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'you cannot exit'.tr,
              style: tt.titleLarge!.copyWith(color: cs.onSurface),
            ),
            content: Text(
              'You cannot use the app until your info are accepted, logout if you want'.tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                ),
              ),
              TextButton(
                onPressed: () => cAC.logout(),
                child: const Text('logout'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.primary,
          title: Text(
            'complete info'.tr.toUpperCase(),
            style: tt.titleMedium!.copyWith(color: cs.onPrimary),
          ),
          //centerTitle: true,
          leading: const Icon(Icons.arrow_back),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       cAC.logout();
          //     },
          //     icon: Icon(
          //       Icons.logout,
          //       color: cs.onPrimary,
          //     ),
          //   )
          // ],
        ),
        body: GetBuilder<CompleteAccountController>(
          builder: (controller) {
            return controller.isLoadingImages
                ? Center(child: SpinKitSquareCircle(color: cs.primary))
                : RefreshIndicator(
                    onRefresh: controller.prepopulateImages,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                      children: [
                        Text(
                          "complete info text".tr,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(height: 12),
                        IdImageSelector(
                          title: "ID (front)".tr,
                          isSubmitted: controller.idFront != null,
                          image: controller.idFront,
                          onTapCamera: () {
                            controller.pickImage("ID (front)".tr, "camera");
                          },
                          onTapGallery: () {
                            controller.pickImage("ID (front)".tr, "gallery");
                          },
                          uploadStatus: user.driverInfo!.idStatus,
                        ),
                        IdImageSelector(
                          title: "ID (rear)".tr,
                          isSubmitted: controller.idRear != null,
                          image: controller.idRear,
                          onTapCamera: () {
                            controller.pickImage("ID (rear)".tr, "camera");
                          },
                          onTapGallery: () {
                            controller.pickImage("ID (rear)".tr, "gallery");
                          },
                          uploadStatus: user.driverInfo!.idStatus,
                        ),
                        IdImageSelector(
                          title: "driving license (front)".tr,
                          isSubmitted: controller.dLicenseFront != null,
                          image: controller.dLicenseFront,
                          onTapCamera: () {
                            controller.pickImage("driving license (front)".tr, "camera");
                          },
                          onTapGallery: () {
                            controller.pickImage("driving license (front)".tr, "gallery");
                          },
                          uploadStatus: user.driverInfo!.licenseStatus,
                        ),
                        IdImageSelector(
                          title: "driving license (rear)".tr,
                          isSubmitted: controller.dLicenseRear != null,
                          image: controller.dLicenseRear,
                          onTapCamera: () {
                            controller.pickImage("driving license (rear)".tr, "camera");
                          },
                          onTapGallery: () {
                            controller.pickImage("driving license (rear)".tr, "gallery");
                          },
                          uploadStatus: user.driverInfo!.licenseStatus,
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          onTap: () {
                            controller.submit();
                          },
                          child: Center(
                            child: controller.isLoading
                                ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                : Text(
                                    "submit".tr.toUpperCase(),
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
