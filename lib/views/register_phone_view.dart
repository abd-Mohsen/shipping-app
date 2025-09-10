import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/register_controller.dart';
import 'package:shipment/views/components/auth_field.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'components/auth_background.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterPhoneView extends StatelessWidget {
  const RegisterPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    RegisterController rC = Get.put(RegisterController());

    return SafeArea(
      child: AuthBackground(
        pageName: "_",
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
          children: <Widget>[
            Column(
              children: [
                Text(
                  "register in the app".tr.toUpperCase(),
                  style: tt.titleLarge!.copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 12,
                      child: Hero(
                        tag: "auth_image",
                        child: SvgPicture.asset("assets/images/driver.svg", height: 300),
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
                    key: rC.phoneFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AuthField(
                          controller: rC.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          label: "your phone".tr,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.phone_android, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(rC.phone.text, 10, 10, "phone");
                          },
                          onChanged: (val) {
                            if (rC.button1Pressed) rC.phoneFormKey.currentState!.validate();
                          },
                        ),
                        const SizedBox(height: 16),
                        GetBuilder<RegisterController>(
                          builder: (controller) {
                            return CustomButton(
                              onTap: () {
                                controller.toOTP();
                              },
                              child: Center(
                                child: controller.isLoading
                                    ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                    : Text(
                                  "send".tr.toUpperCase(),
                                  style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            "enter your phone to create an account".tr,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                          ),
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
