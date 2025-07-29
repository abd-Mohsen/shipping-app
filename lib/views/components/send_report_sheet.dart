import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/send_report_controller.dart';
import 'package:shipment/views/components/blurred_sheet.dart';
import 'package:shipment/views/components/input_field.dart';
import 'auth_field.dart';

class SendReportSheet extends StatelessWidget {
  const SendReportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    SendReportController sRC = Get.put(SendReportController());

    return BlurredSheet(
        height: MediaQuery.of(context).size.height / 2.5,
        content: GetBuilder<SendReportController>(
          builder: (controller) {
            return Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: InputField(
                      controller: controller.subject,
                      label: "subject".tr,
                      textInputAction: TextInputAction.next,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: Icons.subject,
                      validator: (val) {
                        return validateInput(controller.subject.text, 1, 10000, "");
                      },
                      onChanged: (val) {
                        controller.formKey.currentState!.validate();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: InputField(
                      controller: controller.message,
                      label: "message".tr,
                      textInputAction: TextInputAction.done,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: Icons.message,
                      validator: (val) {
                        return validateInput(controller.message.text, 1, 100000, "");
                      },
                      onChanged: (val) {
                        controller.formKey.currentState!.validate();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        title: "send a report".tr,
        confirmText: "send".tr.toUpperCase(),
        onConfirm: () {
          sRC.sendReport();
        });
  }
}
