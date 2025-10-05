import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SelectOtpMethodSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 16, left: 8, right: 8),
            child: Text(
              "how do you want to receive the code?".tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.whatsapp,
              color: Color(0xff21c162),
            ),
            title: Text(
              "whatsapp".tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
            onTap: onTapWhatsapp,
          ),
          ListTile(
            leading: Icon(
              Icons.sms_outlined,
              color: cs.onSurface,
            ),
            title: Text(
              "sms message".tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
            onTap: onTapSMS,
          ),
          ListTile(
            leading: Icon(
              Icons.email_outlined,
              color: cs.onSurface,
            ),
            title: Text(
              "email".tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
            onTap: onTapEmail,
          ),
        ],
      ),
    );
  }
}
