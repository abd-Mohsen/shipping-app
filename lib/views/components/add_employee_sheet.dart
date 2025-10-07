import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/components/blurred_sheet.dart';
import 'package:shipment/views/components/input_field.dart';
import 'package:shipment/views/components/select_otp_method_sheet.dart';
import 'auth_field.dart';

class AddEmployeeSheet extends StatelessWidget {
  const AddEmployeeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // ColorScheme cs = Theme.of(context).colorScheme;
    // TextTheme tt = Theme.of(context).textTheme;
    CompanyHomeController cHC = Get.find();
    return GetBuilder<CompanyHomeController>(builder: (controller) {
      return BlurredSheet(
        height: MediaQuery.of(context).size.height / 3,
        isLoading: cHC.isLoadingEmployeesAdd,
        content: Form(
          key: controller.addEmployeeFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: InputField(
              controller: controller.phone,
              label: "employee phone".tr,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.phone_android,
              validator: (val) {
                return validateInput(controller.phone.text, 10, 12, "", wholeNumber: true);
              },
              onChanged: (val) {
                if (controller.employeeButtonPressed) controller.addEmployeeFormKey.currentState!.validate();
              },
            ),
          ),
        ),
        title: "add employee".tr,
        confirmText: "add".tr,
        onConfirm: () {
          if (!controller.addEmployeeFormKey.currentState!.validate()) return;
          showModalBottomSheet(
            context: context,
            builder: (_) => SelectOtpMethodSheet(
              onTapWhatsapp: () => cHC.addEmployee("whatsapp"),
              onTapEmail: () => cHC.addEmployee("email"),
              onTapSMS: () => cHC.addEmployee("sms"),
            ),
          );
        },
      );
    });
  }
}
