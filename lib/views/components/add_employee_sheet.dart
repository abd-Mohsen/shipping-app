import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/input_field.dart';
import 'auth_field.dart';

class AddEmployeeSheet extends StatelessWidget {
  const AddEmployeeSheet({super.key});

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
            key: controller.addEmployeeFormKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                InputField(
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
                CustomButton(
                  onTap: () {
                    controller.addEmployee();
                  },
                  child: Center(
                    child: controller.isLoadingEmployeesAdd
                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                        : Text(
                            "add".tr.toUpperCase(),
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
