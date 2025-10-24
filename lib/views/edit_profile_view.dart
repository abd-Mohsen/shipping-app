import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/edit_profile_controller.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/input_field.dart';
import 'package:shipment/views/reset_pass_view1.dart';
import 'components/auth_field.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    EditProfileController ePC = Get.put(EditProfileController());
    CurrentUserController cUC = Get.find();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.secondaryContainer,
          title: Text(
            'edit profile'.tr,
            style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "warning".tr,
                  titleStyle: tt.titleMedium!.copyWith(color: cs.onSurface),
                  titlePadding: const EdgeInsets.symmetric(vertical: 12.0),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "do you want to delete your account?".tr,
                      style: tt.titleLarge!.copyWith(color: cs.onSurface),
                    ),
                  ),
                  confirm: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              "enter your password to delete your account".tr,
                              style: tt.titleMedium!.copyWith(color: cs.onSurface),
                            ),
                            content: GetBuilder<EditProfileController>(
                              builder: (controller) {
                                return Form(
                                  key: controller.deleteFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AuthField(
                                        controller: ePC.oldPass,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        obscure: !ePC.oldPasswordVisible,
                                        label: "password".tr,
                                        fillColor: cs.secondaryContainer,
                                        bordered: true,
                                        fontColor: cs.onSecondaryContainer,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Icon(Icons.lock, color: cs.primary),
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap: () => ePC.toggleOldPasswordVisibility(!ePC.oldPasswordVisible),
                                          child: Icon(
                                            ePC.oldPasswordVisible
                                                ? CupertinoIcons.eye_slash_fill
                                                : CupertinoIcons.eye_fill,
                                            color: cs.primary,
                                          ),
                                        ),
                                        validator: (val) {
                                          return validateInput(ePC.oldPass.text, 0, 50, "");
                                        },
                                        onChanged: (val) {
                                          if (ePC.button3Pressed) ePC.deleteFormKey.currentState!.validate();
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      CustomButton(
                                        onTap: () {
                                          controller.deleteAccount();
                                        },
                                        color: cs.error,
                                        child: Center(
                                          child: controller.isLoadingDelete
                                              ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                              : Text(
                                                  "delete".tr.toUpperCase(),
                                                  style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                                ),
                                        ),
                                      ),
                                      CustomButton(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Center(
                                          child: Text(
                                            "cancel".tr.toUpperCase(),
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
                      },
                      child: Text(
                        "yes".tr,
                        style: tt.titleSmall!.copyWith(color: Colors.red),
                      ),
                    ),
                  ),
                  cancel: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "no".tr,
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.delete,
                color: cs.error,
              ),
            )
          ],
          bottom: TabBar(
            indicatorColor: cs.primary,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.person,
                    color: cs.onSecondaryContainer,
                    size: 23,
                  ),
                ),
                child: Text(
                  "profile".tr,
                  style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.lock,
                    color: cs.onSecondaryContainer,
                    size: 23,
                  ),
                ),
                child: Text(
                  "password".tr,
                  style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
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
                        controller: controller.middleName,
                        label: "middle name".tr,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.person,
                        validator: (val) {
                          return validateInput(controller.middleName.text, 2, 200, "text");
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
                        visible: cUC.currentUser!.role.type == "company",
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
                        child: SvgPicture.asset("assets/images/password.svg", height: 200),
                      ),
                      AuthField(
                        controller: controller.oldPass,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        obscure: !controller.oldPasswordVisible,
                        label: "old password".tr,
                        fillColor: cs.secondaryContainer,
                        bordered: true,
                        fontColor: cs.onSecondaryContainer,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 8),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => const ResetPassView1());
                          },
                          child: Text(
                            "forgot password?".tr,
                            style: tt.labelMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      AuthField(
                        controller: controller.newPass,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        obscure: !controller.passwordVisible,
                        label: "new password".tr,
                        fillColor: cs.secondaryContainer,
                        bordered: true,
                        fontColor: cs.onSecondaryContainer,
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
                        label: "re enter new password".tr,
                        fillColor: cs.secondaryContainer,
                        bordered: true,
                        fontColor: cs.onSecondaryContainer,
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
                          return validateInput(
                            controller.reNewPass.text,
                            8,
                            50,
                            "",
                            pass: controller.newPass.text,
                            rePass: controller.reNewPass.text,
                          );
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
