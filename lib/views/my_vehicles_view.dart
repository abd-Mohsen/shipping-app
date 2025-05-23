import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/my_vehicles_controller.dart';
import 'package:shipment/views/components/add_vehicle_sheet.dart';
import 'package:shipment/views/components/vehicle_card.dart';

class MyVehiclesView extends StatelessWidget {
  const MyVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MyVehiclesController mVC = Get.put(MyVehiclesController());
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
            visible: controller.myVehicles.isEmpty,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  builder: (BuildContext context) => AddVehicleSheet(),
                );
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
    );
  }
}
