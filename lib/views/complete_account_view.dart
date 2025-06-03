import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/controllers/complete_account_controller.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/id_image_selector.dart';

class CompleteAccountView extends StatelessWidget {
  const CompleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    CompleteAccountController cAC = Get.find();

    GetStorage getStorage = GetStorage();
    bool isDriver = !["company", "customer"].contains(getStorage.read("role"));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, res) {
        if (didPop) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'you cannot exit'.tr,
              style: tt.titleLarge!.copyWith(color: cs.onSurface),
            ),
            content: Text(
              'you cannot use the app until your info are accepted, logout if you want'.tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ok'.tr,
                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                ),
              ),
              TextButton(
                onPressed: () => cAC.logout(),
                child: Text(
                  'logout'.tr,
                  style: tt.titleSmall!.copyWith(color: cs.error),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.secondaryContainer,
          title: Text(
            'complete info'.tr.toUpperCase(),
            style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
          ),
          //centerTitle: true,
          leading: null,
          actions: [
            // IconButton(
            //   onPressed: () {
            //     cAC.logout();
            //   },
            //   icon: Icon(
            //     Icons.logout,
            //     color: cs.onPrimary,
            //   ),
            // ),
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "help".tr,
                  titleStyle: tt.titleLarge!.copyWith(color: cs.onSurface),
                  titlePadding: const EdgeInsets.only(top: 20),
                  content: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.watch_later_outlined, color: cs.onSurface),
                        title: Text(
                          "pending, wait for response".tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.task_alt, color: Colors.green),
                        title: Text(
                          "accepted, no need to change".tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.close, color: Colors.red),
                        title: Text(
                          "refused, upload another image then submit".tr,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.info_outline,
                color: cs.onSecondaryContainer,
              ),
            ),
          ],
        ),
        body: GetBuilder<CompleteAccountController>(
          builder: (controller) {
            return controller.isLoadingImages
                ? Center(child: SpinKitSquareCircle(color: cs.primary))
                : RefreshIndicator(
                    onRefresh: controller.prepopulateImages,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      children: [
                        Text(
                          controller.msg.tr,
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
                          uploadStatus: controller.idStatus,
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
                          uploadStatus: controller.idStatus,
                        ),
                        if (isDriver)
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
                            uploadStatus: controller.licenseStatus,
                          ),
                        if (isDriver)
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
                            uploadStatus: controller.licenseStatus,
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
