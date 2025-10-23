import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/register_controller.dart';
import 'package:shipment/views/components/auth_field.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'components/auth_background.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// this is where user specify password for his account to register it

class RegisterView2 extends StatelessWidget {
  const RegisterView2({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    RegisterController rC = Get.find();

    return SafeArea(
      child: AuthBackground(
        pageName: "otp",
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 9),
          children: <Widget>[
            Column(
              children: [
                Text(
                  "set password for your account".tr.toUpperCase(),
                  style: tt.titleMedium!.copyWith(color: cs.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 12,
                      child: Hero(
                        tag: "auth_image",
                        child: SvgPicture.asset("assets/images/password.svg", height: 300),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8 * 2),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Form(
                    key: rC.passwordFormKey,
                    child: GetBuilder<RegisterController>(builder: (controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AuthField(
                            controller: rC.password,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            obscure: !controller.passwordVisible,
                            label: "password".tr,
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
                              return validateInput(rC.password.text, 8, 50, "");
                            },
                            onChanged: (val) {
                              if (rC.button2Pressed) rC.passwordFormKey.currentState!.validate();
                            },
                          ),
                          AuthField(
                            controller: rC.rePassword,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            obscure: !controller.rePasswordVisible,
                            label: "re enter password".tr,
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
                                rC.rePassword.text,
                                8,
                                50,
                                "",
                                pass: controller.password.text,
                                rePass: controller.rePassword.text,
                              );
                            },
                            onChanged: (val) {
                              if (rC.button2Pressed) rC.passwordFormKey.currentState!.validate();
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                              onTap: () {
                                controller.register();
                              },
                              child: Center(
                                child: controller.isLoading
                                    ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                    : Text(
                                        "ok".tr.toUpperCase(),
                                        style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                      ),
                              )),
                        ],
                      );
                    }),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: Text(
                  "you can fill the remaining data after logging in to your account".tr,
                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
