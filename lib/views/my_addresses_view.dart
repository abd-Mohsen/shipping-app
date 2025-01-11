import 'package:flutter/material.dart';
import 'package:shipment/controllers/my_addresses_controller.dart';
import 'package:get/get.dart';

class MyAddressesView extends StatelessWidget {
  const MyAddressesView({super.key});

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
          'my addresses'.toUpperCase(),
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          //
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //open map to select
        },
        child: Icon(Icons.add, color: cs.onPrimary),
        foregroundColor: cs.onPrimary,
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
