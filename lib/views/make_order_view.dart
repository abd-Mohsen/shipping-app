import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/map_selector.dart';

import '../controllers/make_order_controller.dart';

class MakeOrderView extends StatelessWidget {
  const MakeOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MakeOrderController mOC = Get.put(MakeOrderController());
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'make an order'.toUpperCase(),
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          //
        ],
      ),
      body: GetBuilder<MakeOrderController>(builder: (controller) {
        return ListView(
          children: [
            MapSelector(
              mapController: controller.mapController1,
              start: true,
              address: controller.sourceState ?? "select location",
              onClose: () {
                controller.calculateStartAddress();
              },
            ),
            MapSelector(
              mapController: controller.mapController2,
              start: false,
              address: controller.targetState ?? "select location",
              onClose: () {
                controller.calculateTargetAddress();
              },
            ),
          ],
        );
      }),
    );
  }
}
