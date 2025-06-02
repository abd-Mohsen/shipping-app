import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/components/blurred_sheet.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/input_field.dart';
import 'auth_field.dart';

class ExportFileSheet extends StatelessWidget {
  const ExportFileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    CompanyHomeController cHC = Get.find();
    return BlurredSheet(
        height: MediaQuery.of(context).size.height / 3,
        content: GetBuilder<CompanyHomeController>(
          builder: (controller) {
            return Form(
              key: controller.exportFileFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: InputField(
                  controller: controller.fileName,
                  label: "file name".tr,
                  textInputAction: TextInputAction.done,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: Icons.attach_file,
                  validator: (val) {
                    return validateInput(
                      controller.fileName.text,
                      1,
                      10000,
                      "",
                    );
                  },
                  onChanged: (val) {
                    controller.exportFileFormKey.currentState!.validate();
                  },
                ),
              ),
            );
          },
        ),
        title: "export excel file".tr,
        confirmText: "export".tr.toUpperCase(),
        onConfirm: () {
          cHC.export();
        });
  }
}
