import 'package:flutter/material.dart';
import 'package:shipment/controllers/my_addresses_controller.dart';
import 'package:get/get.dart';

class MyVehiclesView extends StatelessWidget {
  const MyVehiclesView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MyAddressesController mAC = Get.put(MyAddressesController());
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
          //add a vehicle (bottom sheet)
        },
        foregroundColor: cs.onPrimary,
        child: Icon(Icons.add, color: cs.onPrimary),
      ),
      body: GetBuilder<MyAddressesController>(builder: (controller) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          children: [
            //
          ],
        );
      }),
    );
  }
}
