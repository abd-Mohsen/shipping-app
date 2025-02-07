import 'package:flutter/material.dart';
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

    return PopScope(
      //todo: prevent from exiting
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.primary,
          title: Text(
            'complete info'.tr.toUpperCase(),
            style: tt.titleMedium!.copyWith(color: cs.onPrimary),
          ),
          //centerTitle: true,
          leading: Icon(Icons.arrow_back),
          actions: [
            IconButton(
              onPressed: () {
                //todo
              },
              icon: Icon(
                Icons.logout,
                color: cs.onPrimary,
              ),
            )
          ],
        ),
        body: GetBuilder<CompleteAccountController>(
          init: CompleteAccountController(user: user),
          builder: (controller) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                Text(
                  'some of your data are refused or not accepted yet, please re upload the refused data'.tr,
                  style: tt.titleSmall!.copyWith(color: cs.onPrimary),
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
                // IdImageSelector(
                //   title: "ID (rear)".tr,
                //   isSubmitted: controller.idRear != null,
                //   image: controller.idRear,
                //   onTapCamera: () {
                //     controller.pickImage("ID (rear)".tr, "camera");
                //   },
                //   onTapGallery: () {
                //     controller.pickImage("ID (rear)".tr, "gallery");
                //   },
                // ),
                // Visibility(
                //   visible: ["driver", "employee"].contains(controller.roles[controller.roleIndex]),
                //   child: IdImageSelector(
                //     title: "driving license (front)".tr,
                //     isSubmitted: controller.dLicenseFront != null,
                //     image: controller.dLicenseFront,
                //     onTapCamera: () {
                //       controller.pickImage("driving license (front)".tr, "camera");
                //     },
                //     onTapGallery: () {
                //       controller.pickImage("driving license (front)".tr, "gallery");
                //     },
                //   ),
                // ),
                // Visibility(
                //   visible: ["driver", "employee"].contains(controller.roles[controller.roleIndex]),
                //   child: IdImageSelector(
                //     title: "driving license (rear)".tr,
                //     isSubmitted: controller.dLicenseRear != null,
                //     image: controller.dLicenseRear,
                //     onTapCamera: () {
                //       controller.pickImage("driving license (rear)".tr, "camera");
                //     },
                //     onTapGallery: () {
                //       controller.pickImage("driving license (rear)".tr, "gallery");
                //     },
                //   ),
                // ),
                CustomButton(
                  onTap: () {
                    //todo
                  },
                  child: Center(
                    child: Text(
                      "submit",
                      style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
