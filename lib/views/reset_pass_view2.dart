import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/reset_password_controller.dart';
import 'package:shipment/views/components/auth_field.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'components/auth_background.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ResetPassView2 extends StatelessWidget {
  const ResetPassView2({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    ResetPassController rPC = Get.find();

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
                  "set new password".toUpperCase(),
                  style: tt.titleLarge!.copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 12,
                      //todo(later): replace png with svg to save space
                      child: Hero(
                        tag: "auth_image",
                        child: Image.asset('assets/images/password.png'),
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
                    key: rPC.secondFormKey,
                    child: GetBuilder<ResetPassController>(builder: (controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AuthField(
                            controller: rPC.newPassword,
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
                              return validateInput(rPC.newPassword.text, 8, 50, "");
                            },
                            onChanged: (val) {
                              if (rPC.button2Pressed) rPC.secondFormKey.currentState!.validate();
                            },
                          ),
                          AuthField(
                            controller: rPC.rePassword,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
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
                              return validateInput(
                                rPC.rePassword.text,
                                8,
                                50,
                                "",
                                pass: controller.newPassword.text,
                                rePass: controller.rePassword.text,
                              );
                            },
                            onChanged: (val) {
                              if (rPC.button2Pressed) rPC.secondFormKey.currentState!.validate();
                            },
                          ),
                          const SizedBox(height: 16),
                          GetBuilder<ResetPassController>(
                            builder: (controller) {
                              return CustomButton(
                                  onTap: () {
                                    controller.resetPass();
                                  },
                                  child: Center(
                                    child: controller.isLoading2
                                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                        : Text(
                                            "ok".toUpperCase(),
                                            style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                          ),
                                  ));
                            },
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              "now you are logged in, you can set a new password",
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
