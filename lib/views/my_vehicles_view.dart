import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/my_vehicles_controller.dart';
import 'package:shipment/views/components/add_vehicle_sheet.dart';
import 'package:shipment/views/components/vehicle_card.dart';

class MyVehiclesView extends StatelessWidget {
  final bool? openSheet;
  const MyVehiclesView({super.key, this.openSheet});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    GetStorage getStorage = GetStorage();
    late DriverHomeController dHC;
    if (getStorage.read("role") == "driver") dHC = Get.find();
    MyVehiclesController mVC =
        (getStorage.read("role") == "driver") ? Get.put(MyVehiclesController()) : Get.put(MyVehiclesController());

    openAddSheet() async {
      await Future.delayed(const Duration(milliseconds: 400));
      showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        enableDrag: true,
        builder: (context) => Padding(
          // 👇 This makes sure the bottom sheet moves up with the keyboard
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const AddVehicleSheet(),
          ),
        ),
      );
    }

    if (openSheet ?? false) openAddSheet();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent, // Add this line
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: cs.surface, // Match your AppBar
        ),
        centerTitle: true,
        title: Text(
          "my vehicles".tr,
          style: tt.titleMedium!.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: GetBuilder<MyVehiclesController>(
        builder: (controller) {
          return Visibility(
            visible:
                controller.myVehicles.isEmpty && !controller.isLoading && getStorage.read("role") != "company_employee",
            child: FloatingActionButton(
              onPressed: () {
                openAddSheet();
              },
              foregroundColor: cs.onPrimary,
              child: Icon(Icons.add, color: cs.onPrimary),
            ),
          );
        },
      ),
      body: GetBuilder<MyVehiclesController>(
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
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
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
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                                confirm: TextButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.deleteVehicle(controller.myVehicles[i].id);
                                  },
                                  child: Text(
                                    "yes".tr,
                                    style: tt.titleSmall!.copyWith(color: Colors.red),
                                  ),
                                ),
                                cancel: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "no".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                );
        },
      ),
    );
  }
}
