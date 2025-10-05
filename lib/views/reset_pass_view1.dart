import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/reset_password_controller.dart';
import 'package:shipment/views/components/auth_field.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'components/auth_background.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'components/select_otp_method_sheet.dart';

class ResetPassView1 extends StatelessWidget {
  const ResetPassView1({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    ResetPassController rPC = Get.put(ResetPassController());

    return SafeArea(
      child: AuthBackground(
        pageName: "otp",
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
          children: <Widget>[
            Column(
              children: [
                Text(
                  "reset password".tr.toUpperCase(),
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
                        child: SvgPicture.asset("assets/images/otp.svg", height: 300),
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
                    key: rPC.firstFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AuthField(
                          controller: rPC.phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          label: "your phone".tr,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.phone_android, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(rPC.phone.text, 10, 10, "phone");
                          },
                          onChanged: (val) {
                            if (rPC.button1Pressed) rPC.firstFormKey.currentState!.validate();
                          },
                        ),
                        const SizedBox(height: 16),
                        GetBuilder<ResetPassController>(
                          builder: (controller) {
                            return CustomButton(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => SelectOtpMethodSheet(
                                    onTapWhatsapp: () => controller.toOTP("whatsapp"),
                                    onTapEmail: () => controller.toOTP("email"),
                                    onTapSMS: () => controller.toOTP("sms"),
                                  ),
                                );
                              },
                              child: Center(
                                child: controller.isLoading1
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
                            "reset pass1 text".tr,
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
