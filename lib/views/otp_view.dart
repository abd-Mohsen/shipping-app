import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shipment/controllers/reset_password_controller.dart';
import 'package:shipment/views/reset_pass_view2.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controllers/otp_controller.dart';
import 'components/auth_background.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OTPView extends StatelessWidget {
  final String source;
  const OTPView({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    late ResetPassController rPC;
    if (source == "reset") rPC = Get.find();
    OTPController oC = Get.put(OTPController(source == "reset" ? rPC : null));

    return SafeArea(
      child: PopScope(
        canPop: true, // make false
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          //todo: show a dialog: are you sure you wanna close otp page?
          //Get.dialog(kCloseAppDialog());
        },
        child: AuthBackground(
          pageName: "otp",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    "enter OTP".toUpperCase(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12, top: 20),
                          child: GetBuilder<OTPController>(
                            builder: (con) => Directionality(
                              textDirection: TextDirection.ltr,
                              child: OTPTextField(
                                //todo(later): let app focus on the first need when resending and when opening page
                                controller: con.otpController,
                                otpFieldStyle: OtpFieldStyle(
                                  focusBorderColor: cs.primary,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                hasError: con.isTimeUp,
                                outlineBorderRadius: 15,
                                length: 5,
                                width: MediaQuery.of(context).size.width / 1.2,
                                fieldWidth: MediaQuery.of(context).size.width / 8,
                                style: tt.labelLarge!.copyWith(color: Colors.black),
                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.box,
                                onCompleted: (pin) {
                                  con.verifyOtp(pin);
                                },
                                onChanged: (val) {},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GetBuilder<OTPController>(
                          builder: (controller) {
                            return ElevatedButton(
                              onPressed: !controller.isTimeUp // remove !
                                  ? () {
                                      //controller.resendOtp();
                                      Get.to(ResetPassView2());
                                    }
                                  : null,
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(controller.isTimeUp ? cs.primary : Colors.grey),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: controller.isLoading
                                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                        : Text(
                                            "resend".toUpperCase(),
                                            style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        GetBuilder<OTPController>(
                          builder: (controller) {
                            return Countdown(
                              controller: controller.timeController,
                              seconds: 180,
                              build: (_, double time) => Text(
                                "enter the code we sent to your phone, you can request a new code after ${time.toInt().toString()} seconds",
                                style: tt.titleSmall!.copyWith(color: cs.onSurface),
                              ),
                              onFinished: () {
                                controller.toggleTimerState(true);
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Visibility(
                            visible: source == "register",
                            child: ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 25,
                              ),
                              title: Text(
                                "logout",
                                style: tt.titleSmall!.copyWith(color: cs.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
