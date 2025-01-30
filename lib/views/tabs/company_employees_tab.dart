import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/components/add_employee_sheet.dart';

import '../components/custom_button.dart';

class CompanyEmployeesTab extends StatelessWidget {
  const CompanyEmployeesTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CompanyHomeController>(builder: (controller) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        children: [
          CustomButton(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                enableDrag: false,
                builder: (BuildContext context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
                  ),
                  child: const AddEmployeeSheet(),
                ),
              );
            },
            child: Center(
              child: Text(
                "add employee".tr.toUpperCase(),
                style: tt.titleSmall!.copyWith(color: cs.onPrimary),
              ),
            ),
          ),
        ],
      );
    });
  }
}
