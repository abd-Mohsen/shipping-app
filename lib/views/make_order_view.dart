import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/input_field.dart';
import 'package:shipment/views/components/map_selector.dart';

import '../controllers/make_order_controller.dart';
import 'components/auth_field.dart';

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
        return Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            children: [
              MapSelector(
                mapController: controller.mapController1,
                start: true,
                address: controller.sourceLocation?.addressEncoder().toString() ?? "select location",
                onClose: () {
                  controller.calculateStartAddress();
                },
              ),
              MapSelector(
                mapController: controller.mapController2,
                start: false,
                address: controller.targetLocation?.addressEncoder().toString() ?? "select location",
                onClose: () {
                  controller.calculateTargetAddress();
                },
              ),
              InputField(
                controller: controller.description,
                label: "description",
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                prefixIcon: Icon(Icons.text_snippet, color: cs.onSurface),
                validator: (val) {
                  return validateInput(controller.description.text, 10, 1000, "text"); //todo check constraints
                },
                onChanged: (val) {
                  if (controller.buttonPressed) controller.formKey.currentState!.validate();
                },
              ),
              InputField(
                controller: controller.price,
                label: "expected price",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                prefixIcon: Icon(Icons.attach_money, color: cs.onSurface),
                validator: (val) {
                  return validateInput(controller.price.text, 1, 10, "", wholeNumber: true); //todo check constraints
                },
                onChanged: (val) {
                  if (controller.buttonPressed) controller.formKey.currentState!.validate();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  controller.makeOrder();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: controller.isLoading
                          ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                          : Text(
                              "make order".toUpperCase(),
                              style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
