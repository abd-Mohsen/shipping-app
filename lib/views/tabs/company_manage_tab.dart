import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/tabs/company_employees_tab.dart';
import 'package:shipment/views/tabs/company_vehicles_tab.dart';

class CompanyManageTab extends StatelessWidget {
  const CompanyManageTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CompanyHomeController>(
      builder: (controller) {
        return TabBarView(
          children: [
            CompanyVehiclesTab(),
            CompanyEmployeesTab(),
          ],
        );
      },
    );
  }
}
