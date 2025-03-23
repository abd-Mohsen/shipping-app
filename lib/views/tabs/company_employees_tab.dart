import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/components/add_employee_sheet.dart';
import 'package:shipment/views/components/employee_card.dart';

import '../components/custom_button.dart';

class CompanyEmployeesTab extends StatelessWidget {
  const CompanyEmployeesTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    //todo: add tracking to employees
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
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
          Expanded(
            child: GetBuilder<CompanyHomeController>(
              builder: (controller) {
                return controller.isLoadingEmployees
                    ? SpinKitSquareCircle(color: cs.primary)
                    : RefreshIndicator(
                        onRefresh: controller.refreshMyEmployees,
                        child: controller.myEmployees.isEmpty
                            ? Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Lottie.asset("assets/animations/driver.json", height: 200),
                                    Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Center(
                                        child: Text(
                                          "no data, pull down to refresh".tr,
                                          style: tt.titleMedium!.copyWith(
                                            color: cs.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                itemCount: controller.myEmployees.length,
                                itemBuilder: (context, i) => EmployeeCard(
                                  employee: controller.myEmployees[i],
                                  onDelete: () {
                                    Get.defaultDialog(
                                      title: "",
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "delete employee?".tr,
                                          style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                        ),
                                      ),
                                      confirm: TextButton(
                                        onPressed: () {
                                          Get.back();
                                          controller.deleteEmployee(controller.myEmployees[i].id);
                                        },
                                        child: Text(
                                          "yes",
                                          style: tt.titleMedium!.copyWith(color: Colors.red),
                                        ),
                                      ),
                                      cancel: TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          "no",
                                          style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
