import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shipment/controllers/register_controller.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/id_image_selector.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/auth_background.dart';
import 'components/auth_field.dart';
import 'components/show_video_dialog.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    RegisterController rC = Get.put(RegisterController());

    return SafeArea(
      child: AuthBackground(
        pageName: "register",
        child: GetBuilder<RegisterController>(builder: (controller) {
          return ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 52),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register as:".tr,
                          style: tt.titleLarge!.copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Get.dialog(const AssetVideoDialog());
                          },
                          child: Icon(Icons.info, color: cs.primary),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      //const Spacer(),
                      Expanded(
                        flex: 3,
                        child: Hero(
                          tag: "auth_image",
                          child: Column(
                            children: [
                              CarouselSlider(
                                items: [
                                  ...rC.roles.map(
                                    (role) => Column(
                                      children: [
                                        SvgPicture.asset("assets/images/$role.svg", height: 120),
                                        Text(
                                          role.tr,
                                          style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  aspectRatio: 16 / 8,
                                  onPageChanged: (i, reason) => rC.setRole(i),
                                  viewportFraction: 1,
                                ),
                              ),
                              //const SizedBox(height: 4),
                              AnimatedSmoothIndicator(
                                activeIndex: rC.roleIndex,
                                count: rC.roles.length,
                                effect: WormEffect(dotHeight: 9, dotWidth: 9, activeDotColor: cs.primary),
                              )
                            ],
                          ),
                        ),
                      ),
                      //const Spacer(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 8,
                    child: Form(
                      key: rC.registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: controller.roles[controller.roleIndex] == "company",
                            child: AuthField(
                              controller: rC.companyName,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              label: "company name".tr,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.house, color: cs.primary),
                              ),
                              validator: (val) {
                                return validateInput(rC.companyName.text, 2, 50, "");
                              },
                              onChanged: (val) {
                                if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                              },
                            ),
                          ),
                          AuthField(
                            controller: rC.firstName,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            label: "first name".tr,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.person, color: cs.primary),
                            ),
                            validator: (val) {
                              return validateInput(rC.firstName.text, 2, 50, "");
                            },
                            onChanged: (val) {
                              if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                            },
                          ),
                          AuthField(
                            controller: rC.middleName,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            label: "middle name".tr,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.person, color: cs.primary),
                            ),
                            validator: (val) {
                              return validateInput(rC.middleName.text, 2, 50, "");
                            },
                            onChanged: (val) {
                              if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                            },
                          ),
                          AuthField(
                            controller: rC.lastName,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            label: "last name".tr,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.person, color: cs.primary),
                            ),
                            validator: (val) {
                              return validateInput(rC.lastName.text, 2, 50, "");
                            },
                            onChanged: (val) {
                              if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                            },
                          ),
                          AuthField(
                            controller: rC.phone,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            label: "phone".tr,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(Icons.phone_android, color: cs.primary),
                            ),
                            validator: (val) {
                              return validateInput(rC.phone.text, 10, 10, "phone");
                            },
                            onChanged: (val) {
                              if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                            },
                          ),
                          GetBuilder<RegisterController>(
                            builder: (controller) {
                              return AuthField(
                                controller: rC.password,
                                obscure: !controller.passwordVisible,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                label: "password".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(Icons.lock, color: cs.primary),
                                ),
                                suffixIcon: controller.passwordVisible
                                    ? GestureDetector(
                                        onTap: () => controller.togglePasswordVisibility(false),
                                        child: Icon(CupertinoIcons.eye_slash_fill, color: cs.primary),
                                      )
                                    : GestureDetector(
                                        onTap: () => controller.togglePasswordVisibility(true),
                                        child: Icon(CupertinoIcons.eye_fill, color: cs.primary),
                                      ),
                                validator: (val) {
                                  return validateInput(rC.password.text, 8, 50, "password");
                                },
                                onChanged: (val) {
                                  if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                                },
                              );
                            },
                          ),
                          GetBuilder<RegisterController>(
                            builder: (controller) {
                              return AuthField(
                                controller: rC.rePassword,
                                obscure: !controller.rePasswordVisible,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                label: "re enter password".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(Icons.lock, color: cs.primary),
                                ),
                                suffixIcon: controller.rePasswordVisible
                                    ? GestureDetector(
                                        onTap: () => controller.toggleRePasswordVisibility(false),
                                        child: Icon(CupertinoIcons.eye_slash_fill, color: cs.primary),
                                      )
                                    : GestureDetector(
                                        onTap: () => controller.toggleRePasswordVisibility(true),
                                        child: Icon(CupertinoIcons.eye_fill, color: cs.primary),
                                      ),
                                validator: (val) {
                                  return validateInput(rC.rePassword.text, 8, 50, "password",
                                      pass: rC.password.text, rePass: rC.rePassword.text);
                                },
                                onChanged: (val) {
                                  if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                                },
                                onTapOutside: (_) {
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                          Visibility(
                            visible: controller.roles[controller.roleIndex] == "employee",
                            child: AuthField(
                              controller: rC.otp,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              label: "registration code".tr,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.numbers, color: cs.primary),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "note".tr,
                                    middleText: "the company must send this code to your phone number".tr,
                                    backgroundColor: cs.surface,
                                    titleStyle: tt.titleMedium!.copyWith(color: cs.onSurface),
                                    middleTextStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                                  );
                                },
                                icon: Icon(
                                  Icons.info,
                                  color: cs.primary,
                                ),
                              ),
                              validator: (val) {
                                return validateInput(rC.otp.text, 4, 6, "", wholeNumber: true);
                              },
                              onChanged: (val) {
                                if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                              },
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          Visibility(
                            visible: controller.roles[controller.roleIndex] != "customer",
                            child: IdImageSelector(
                              title: "ID (front)".tr,
                              isSubmitted: controller.idFront != null,
                              image: controller.idFront,
                              onTapCamera: () {
                                controller.pickImage("ID (front)".tr, "camera");
                              },
                              onTapGallery: () {
                                controller.pickImage("ID (front)".tr, "gallery");
                              },
                            ),
                          ),
                          Visibility(
                            visible: controller.roles[controller.roleIndex] != "customer",
                            child: IdImageSelector(
                              title: "ID (rear)".tr,
                              isSubmitted: controller.idRear != null,
                              image: controller.idRear,
                              onTapCamera: () {
                                controller.pickImage("ID (rear)".tr, "camera");
                              },
                              onTapGallery: () {
                                controller.pickImage("ID (rear)".tr, "gallery");
                              },
                            ),
                          ),
                          Visibility(
                            visible: ["driver", "employee"].contains(controller.roles[controller.roleIndex]),
                            child: IdImageSelector(
                              title: "driving license (front)".tr,
                              isSubmitted: controller.dLicenseFront != null,
                              image: controller.dLicenseFront,
                              onTapCamera: () {
                                controller.pickImage("driving license (front)".tr, "camera");
                              },
                              onTapGallery: () {
                                controller.pickImage("driving license (front)".tr, "gallery");
                              },
                            ),
                          ),
                          Visibility(
                            visible: ["driver", "employee"].contains(controller.roles[controller.roleIndex]),
                            child: IdImageSelector(
                              title: "driving license (rear)".tr,
                              isSubmitted: controller.dLicenseRear != null,
                              image: controller.dLicenseRear,
                              onTapCamera: () {
                                controller.pickImage("driving license (rear)".tr, "camera");
                              },
                              onTapGallery: () {
                                controller.pickImage("driving license (rear)".tr, "gallery");
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          GetBuilder<RegisterController>(
                            builder: (controller) {
                              return CustomButton(
                                onTap: () {
                                  controller.register();
                                },
                                child: Center(
                                  child: controller.isLoading
                                      ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                      : Text(
                                          "register".tr.toUpperCase(),
                                          style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
