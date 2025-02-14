import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/edit_profile_controller.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/input_field.dart';

import '../models/user_model.dart';
import 'components/auth_field.dart';

class EditProfileView extends StatelessWidget {
  final UserModel user;
  final dynamic homeController;
  const EditProfileView({super.key, required this.user, required this.homeController});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    EditProfileController mOC = Get.put(EditProfileController(user: user, homeController: homeController));
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'edit profile'.tr,
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          //
        ],
      ),
      body: GetBuilder<EditProfileController>(
        builder: (controller) {
          return Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SvgPicture.asset("assets/images/edit_profile.svg", height: 200),
                ),
                InputField(
                  controller: controller.firstName,
                  label: "first name".tr,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person,
                  validator: (val) {
                    return validateInput(controller.firstName.text, 2, 200, "text");
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                InputField(
                  controller: controller.lastName,
                  label: "last name".tr,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person,
                  validator: (val) {
                    return validateInput(controller.lastName.text, 2, 200, "text");
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                Visibility(
                  visible: user.role.type == "company",
                  child: InputField(
                    controller: controller.companyName,
                    label: "company name".tr,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.house,
                    validator: (val) {
                      return validateInput(controller.companyName.text, 2, 200, "text");
                    },
                    onChanged: (val) {
                      if (controller.buttonPressed) controller.formKey.currentState!.validate();
                    },
                  ),
                ),
                CustomButton(
                  onTap: () {
                    controller.submit();
                  },
                  child: Center(
                    child: controller.isLoading
                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                        : Text(
                            "edit".tr.toUpperCase(),
                            style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
