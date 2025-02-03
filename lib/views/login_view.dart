import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/login_controller.dart';
import 'package:shipment/views/components/auth_field.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/register_view.dart';
import 'package:shipment/views/reset_pass_view1.dart';
import 'components/auth_background.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    LoginController lC = Get.put(LoginController());

    return SafeArea(
      child: AuthBackground(
        pageName: "login",
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "welcome back".tr.toUpperCase(),
                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 16,
                        //todo: replace png with svg to save space
                        child: Hero(
                          tag: "auth_image",
                          child: Image.asset('assets/images/driver.png'),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8 * 2),
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Form(
                    key: lC.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AuthField(
                          controller: lC.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          label: "phone".tr,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.phone_android, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(lC.phone.text, 10, 10, "phone");
                          },
                          onChanged: (val) {
                            if (lC.buttonPressed) lC.loginFormKey.currentState!.validate();
                          },
                        ),
                        GetBuilder<LoginController>(builder: (controller) {
                          return AuthField(
                            controller: lC.password,
                            obscure: !controller.passwordVisible,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
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
                              return validateInput(lC.password.text, 0, 50, "password");
                            },
                            onChanged: (val) {
                              if (lC.buttonPressed) lC.loginFormKey.currentState!.validate();
                            },
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const ResetPassView1());
                            },
                            child: Text(
                              "forgot password?".tr,
                              style: tt.labelMedium!.copyWith(color: cs.onBackground.withOpacity(0.7)),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GetBuilder<LoginController>(
                          builder: (controller) {
                            return CustomButton(
                              onTap: () {
                                controller.login();
                              },
                              child: Center(
                                child: controller.isLoading
                                    ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                    : Text(
                                        "login".tr.toUpperCase(),
                                        style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "don’t have an Account? ".tr,
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => RegisterView());
                              },
                              child: Text(
                                "register here".tr,
                                style: tt.titleSmall!.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
