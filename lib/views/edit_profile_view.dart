import 'package:flutter/cupertino.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.primary,
          title: Text(
            'edit profile'.tr,
            style: tt.titleMedium!.copyWith(color: cs.onPrimary),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Color(0xff7fff00),
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.person,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text(
                  "profile".tr,
                  style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text(
                  "password".tr,
                  style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: GetBuilder<EditProfileController>(
          builder: (controller) {
            return TabBarView(
              children: [
                Form(
                  key: controller.profileFormKey,
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
                          if (controller.button1Pressed) controller.profileFormKey.currentState!.validate();
                        },
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                          if (controller.button1Pressed) controller.profileFormKey.currentState!.validate();
                        },
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                            if (controller.button1Pressed) controller.profileFormKey.currentState!.validate();
                          },
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                      ),
                      CustomButton(
                        onTap: () {
                          controller.submitProfile();
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
                ),
                //
                Form(
                  key: controller.passFormKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SvgPicture.asset("assets/images/edit_profile.svg", height: 200),
                      ),
                      AuthField(
                        controller: controller.oldPass,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        obscure: !controller.oldPasswordVisible,
                        label: "old password",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.lock, color: cs.primary),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => controller.toggleOldPasswordVisibility(!controller.oldPasswordVisible),
                          child: Icon(
                            controller.oldPasswordVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                            color: cs.primary,
                          ),
                        ),
                        validator: (val) {
                          return validateInput(controller.oldPass.text, 8, 50, "");
                        },
                        onChanged: (val) {
                          if (controller.button2Pressed) controller.passFormKey.currentState!.validate();
                        },
                      ),
                      AuthField(
                        controller: controller.newPass,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        obscure: !controller.passwordVisible,
                        label: "new password",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.lock, color: cs.primary),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => controller.togglePasswordVisibility(!controller.passwordVisible),
                          child: Icon(
                            controller.passwordVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                            color: cs.primary,
                          ),
                        ),
                        validator: (val) {
                          return validateInput(controller.newPass.text, 8, 50, "");
                        },
                        onChanged: (val) {
                          if (controller.button2Pressed) controller.passFormKey.currentState!.validate();
                        },
                      ),
                      AuthField(
                        controller: controller.reNewPass,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        obscure: !controller.rePasswordVisible,
                        label: "re enter new password",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.lock, color: cs.primary),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () => controller.toggleRePasswordVisibility(!controller.rePasswordVisible),
                          child: Icon(
                            controller.rePasswordVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                            color: cs.primary,
                          ),
                        ),
                        validator: (val) {
                          return validateInput(controller.reNewPass.text, 8, 50, "");
                        },
                        onChanged: (val) {
                          if (controller.button2Pressed) controller.passFormKey.currentState!.validate();
                        },
                      ),
                      const SizedBox(height: 8),
                      CustomButton(
                        onTap: () {
                          controller.submitPass();
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
