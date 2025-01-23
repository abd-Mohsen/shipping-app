import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shipment/controllers/register_controller.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/id_image_selector.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'components/auth_background.dart';
import 'components/auth_field.dart';

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
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 40),
                      child: Text(
                        "Register as:".tr,
                        style: tt.titleLarge!.copyWith(color: cs.onSurface),
                      ),
                    ),
                    Row(
                      children: [
                        //const Spacer(),
                        Expanded(
                          flex: 3,
                          //todo: replace png with svg to save space
                          //todo: put arrows around the pic
                          child: Hero(
                            tag: "auth_image",
                            child: Column(
                              children: [
                                CarouselSlider(
                                  items: [
                                    ...rC.roles.map(
                                      (role) => Column(
                                        children: [
                                          SizedBox(height: 150, child: Image.asset('assets/images/$role.png')),
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
                            //todo: add fields and hide them based on role
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
                                  return validateInput(rC.companyName.text, 4, 50, "");
                                },
                                onChanged: (val) {
                                  if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                                },
                              ),
                            ),
                            Visibility(
                              visible: controller.roles[controller.roleIndex] == "company",
                              child: AuthField(
                                controller: rC.numberOfVehicles,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                label: "number of vehicles".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Icon(Icons.local_shipping, color: cs.primary),
                                ),
                                validator: (val) {
                                  return validateInput(rC.numberOfVehicles.text, 4, 50, ""); //todo: this is a number
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
                                return validateInput(rC.firstName.text, 4, 50, "");
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
                                return validateInput(rC.lastName.text, 4, 50, "");
                              },
                              onChanged: (val) {
                                if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                              },
                            ),
                            AuthField(
                              controller: rC.userName,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              label: "user name".tr,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.person, color: cs.primary),
                              ),
                              validator: (val) {
                                return validateInput(rC.userName.text, 4, 50, "", english: true);
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
                                    return validateInput(rC.password.text, 4, 50, "password");
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
                                  textInputAction: TextInputAction.done,
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
                                    return validateInput(rC.rePassword.text, 4, 50, "password",
                                        pass: rC.password.text, rePass: rC.rePassword.text);
                                  },
                                  onChanged: (val) {
                                    if (rC.buttonPressed) rC.registerFormKey.currentState!.validate();
                                  },
                                );
                              },
                            ),
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
                            ),
                            Visibility(
                              visible: controller.roles[controller.roleIndex] == "driver",
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
                              visible: controller.roles[controller.roleIndex] == "driver",
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
                                return ElevatedButton(
                                  onPressed: () {
                                    controller.register();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: controller.isLoading
                                            ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                            : Text(
                                                "register".tr.toUpperCase(),
                                                style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                              ),
                                      ),
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
            ),
          );
        }),
      ),
    );
  }
}
