import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
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
    return GetBuilder<CompanyHomeController>(
      builder: (controller) {
        return Container(
          height: MediaQuery.of(context).size.height / 4.5,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: controller.exportFileFormKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                InputField(
                  controller: controller.fileName,
                  label: "file name".tr,
                  textInputAction: TextInputAction.done,
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
                CustomButton(
                  onTap: () {
                    controller.export();
                  },
                  child: Center(
                    child: Text(
                      "export".tr.toUpperCase(),
                      style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
