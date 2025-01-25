import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
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
        backgroundColor: cs.primary,
        title: Text(
          'my vehicles'.tr.toUpperCase(),
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
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
      body: GetBuilder<MyVehiclesController>(
        builder: (controller) {
          return controller.isLoading
              ? SpinKitSquareCircle(color: cs.primary)
              : RefreshIndicator(
                  onRefresh: controller.refreshMyVehicles,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    itemCount: controller.myVehicles.length,
                    itemBuilder: (context, i) => VehicleCard(
                      vehicle: controller.myVehicles[i],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
