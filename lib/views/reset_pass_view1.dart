import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/reset_password_controller.dart';
import 'package:shipment/views/components/auth_field.dart';
import 'package:shipment/views/otp_view.dart';
import 'components/auth_background.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(
                  "reset password".toUpperCase(),
                  style: tt.titleLarge!.copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 12,
                      //todo: replace png with svg to save space
                      child: Hero(
                        tag: "auth_image",
                        child: Image.asset('assets/images/sms1.png'),
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
                          label: "your phone",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.phone_android, color: cs.primary),
                          ),
                          validator: (val) {
                            return validateInput(rPC.phone.text, 4, 50, "phone");
                          },
                          onChanged: (val) {
                            if (rPC.button1Pressed) rPC.firstFormKey.currentState!.validate();
                          },
                        ),
                        const SizedBox(height: 16),
                        GetBuilder<ResetPassController>(
                          builder: (controller) {
                            return ElevatedButton(
                              onPressed: () {
                                controller.toOTP();
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: controller.isLoading1
                                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                        : Text(
                                            "send".toUpperCase(),
                                            style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            "this will send a code as an sms to the phone number associated with your account.",
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
