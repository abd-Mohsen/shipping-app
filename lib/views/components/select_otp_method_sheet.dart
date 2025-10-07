import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/custom_button.dart';

class SelectOtpMethodSheet extends StatefulWidget {
  final void Function()? onTapWhatsapp;
  final void Function()? onTapEmail;
  final void Function()? onTapSMS;
  const SelectOtpMethodSheet({
    super.key,
    this.onTapWhatsapp,
    this.onTapEmail,
    this.onTapSMS,
  });

  @override
  State<SelectOtpMethodSheet> createState() => _SelectOtpMethodSheetState();
}

class _SelectOtpMethodSheetState extends State<SelectOtpMethodSheet> {
  String selectedValue = "whatsapp";

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: RadioGroup<String>(
        groupValue: selectedValue,
        onChanged: (String? value) {
          setState(() => selectedValue = value!);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 16, left: 8, right: 8),
              child: Text(
                "how do you want to receive the code?".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
            RadioListTile<String>(
              value: 'whatsapp',
              secondary: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Color(0xff21c162),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text(
                "whatsapp".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
            RadioListTile<String>(
              value: 'sms',
              secondary: Icon(
                Icons.sms_outlined,
                color: cs.onSurface,
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text(
                "sms message".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
            RadioListTile<String>(
              value: 'email',
              secondary: Icon(
                Icons.email_outlined,
                color: cs.onSurface,
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              title: Text(
                "email".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.sms_outlined,
            //     color: cs.onSurface,
            //   ),
            //   title: Text(
            //     "sms message".tr,
            //     style: tt.titleSmall!.copyWith(color: cs.onSurface),
            //   ),
            //   onTap: widget.onTapSMS,
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.email_outlined,
            //     color: cs.onSurface,
            //   ),
            //   title: Text(
            //     "email".tr,
            //     style: tt.titleSmall!.copyWith(color: cs.onSurface),
            //   ),
            //   onTap: widget.onTapEmail,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: CustomButton(
                onTap: () {
                  if (selectedValue == "whatsapp") widget.onTapWhatsapp!();
                  if (selectedValue == "sms") widget.onTapSMS!();
                  if (selectedValue == "email") widget.onTapEmail!();
                  Get.back();
                },
                child: Center(
                  child: Text(
                    "ok".tr,
                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
