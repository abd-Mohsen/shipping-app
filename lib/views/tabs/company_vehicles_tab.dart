import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/components/add_vehicle_sheet.dart';

import '../../controllers/my_vehicles_controller.dart';
import '../components/custom_button.dart';
import '../components/vehicle_card.dart';

class CompanyVehiclesTab extends StatelessWidget {
  const CompanyVehiclesTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    MyVehiclesController mVC = Get.put(MyVehiclesController());
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

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
                  child: const AddVehicleSheet(),
                ),
              );
            },
            child: Center(
              child: Text(
                "add vehicle".tr.toUpperCase(),
                style: tt.titleSmall!.copyWith(color: cs.onPrimary),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<MyVehiclesController>(
              builder: (controller) {
                return controller.isLoading
                    ? SpinKitSquareCircle(color: cs.primary)
                    : RefreshIndicator(
                        onRefresh: controller.refreshMyVehicles,
                        child: controller.myVehicles.isEmpty
                            ? Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Lottie.asset("assets/animations/simple truck.json", height: 200),
                                    Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Center(
                                        child: Text(
                                          "no vehicles, pull down to refresh".tr,
                                          style:
                                              tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                itemCount: controller.myVehicles.length,
                                itemBuilder: (context, i) => VehicleCard(
                                  vehicle: controller.myVehicles[i],
                                  onDelete: () {
                                    Get.defaultDialog(
                                      title: "",
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "delete the vehicle?".tr,
                                          style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                        ),
                                      ),
                                      confirm: TextButton(
                                        onPressed: () {
                                          Get.back();
                                          controller.deleteVehicle(controller.myVehicles[i].id);
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
