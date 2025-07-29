import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/views/components/add_vehicle_sheet.dart';

import '../../controllers/my_vehicles_controller.dart';
import '../components/custom_button.dart';
import '../components/vehicle_card.dart';

class CompanyVehiclesTab extends StatelessWidget {
  const CompanyVehiclesTab({super.key});

  @override
  Widget build(BuildContext context) {
    //CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onTap: () {
                showMaterialModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.black.withValues(alpha: 0.5),
                  enableDrag: true,
                  builder: (context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
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
