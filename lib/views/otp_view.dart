import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shipment/views/components/custom_button.dart';
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
    // late ResetPassController rPC;
    // if (source == "reset") rPC = Get.find();
    //OTPController oC = Get.find();
    // late CurrentUserController cUC;
    // if (source == "register") cUC = Get.find();

    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, res) {
          if (didPop) return;

          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     title: Text(
          //       'do you wanna exit?'.tr,
          //       style: tt.titleLarge!.copyWith(color: cs.onSurface),
          //     ),
          //     content: Text(
          //       'you will have to wait to request a new code'.tr,
          //       style: tt.titleSmall!.copyWith(color: cs.onSurface),
          //     ),
          //     actions: [
          //       TextButton(
          //         onPressed: () {},
          //         child: Text(
          //           'cancel'.tr,
          //           style: tt.titleSmall!.copyWith(color: cs.onSurface),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () => Get.back(),
          //         child: Text(
          //           'ok'.tr,
          //           style: tt.titleSmall!.copyWith(color: cs.error),
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        },
        child: AuthBackground(
          pageName: "otp",
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
            children: <Widget>[
              Column(
                children: [
                  Text(
                    "enter OTP".tr.toUpperCase(),
                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: 16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12, top: 20),
                          child: GetBuilder<OTPController>(
                            builder: (con) => Directionality(
                              textDirection: TextDirection.ltr,
                              child: OTPTextField(
                                controller: con.otpFieldController,
                                otpFieldStyle: OtpFieldStyle(
                                  focusBorderColor: cs.primary,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                hasError: con.isTimeUp,
                                outlineBorderRadius: 15,
                                length: 6,
                                width: MediaQuery.of(context).size.width / 1.2,
                                fieldWidth: MediaQuery.of(context).size.width / 10,
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
                            return CustomButton(
                              onTap: controller.isTimeUp
                                  ? () {
                                      controller.resendOtp();
                                    }
                                  : null,
                              color: !controller.isTimeUp ? Colors.grey : cs.primary,
                              child: Center(
                                child: controller.isLoading
                                    ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                    : Text(
                                        "resend".tr.toUpperCase(),
                                        style: tt.titleSmall!.copyWith(color: cs.onPrimary),
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
                                "${"OTP text".tr} ${time.toInt().toString()}",
                                style: tt.titleSmall!.copyWith(color: cs.onSurface),
                              ),
                              onFinished: () {
                                controller.toggleTimerState(true);
                              },
                            );
                          },
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 16),
                        //   child: Visibility(
                        //     visible: source == "register",
                        //     child: ListTile(
                        //       leading: const Icon(
                        //         Icons.logout,
                        //         color: Colors.red,
                        //         size: 25,
                        //       ),
                        //       onTap: () {
                        //         cUC.logout(); //todo test
                        //       },
                        //       title: Text(
                        //         "logout".tr,
                        //         style: tt.titleSmall!.copyWith(color: cs.error),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
