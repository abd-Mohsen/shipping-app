import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SvgPicture.asset("assets/images/make_order.svg", height: 200),
              ),
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
                prefixIcon: Icons.text_snippet,
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
                prefixIcon: Icons.attach_money,
                validator: (val) {
                  return validateInput(controller.price.text, 1, 10, "", wholeNumber: true); //todo check constraints
                },
                onChanged: (val) {
                  if (controller.buttonPressed) controller.formKey.currentState!.validate();
                },
              ),
              InputField(
                controller: controller.weight,
                label: "weight with unit",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.monitor_weight,
                validator: (val) {
                  return validateInput(controller.weight.text, 1, 100, ""); //todo check constraints
                },
                onChanged: (val) {
                  if (controller.buttonPressed) controller.formKey.currentState!.validate();
                },
              ),
              InputField(
                controller: controller.otherInfo,
                label: "other info (optional)",
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                prefixIcon: Icons.note,
                validator: (val) {
                  return validateInput(
                    controller.otherInfo.text,
                    0,
                    1000,
                    "",
                    canBeEmpty: true,
                  ); //todo check constraints
                },
                onChanged: (val) {
                  if (controller.buttonPressed) controller.formKey.currentState!.validate();
                },
              ),
              controller.isLoadingPayment //todo: add refresh button
                  ? SpinKitThreeBounce(color: cs.primary, size: 20)
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: MultiDropdown<PaymentMethodModel>(
                        items: controller.paymentMethods
                            .map(
                              (paymentMethod) => DropdownItem(
                                label: paymentMethod.name,
                                value: paymentMethod,
                              ),
                            )
                            .toList(),
                        controller: controller.paymentMethodController,
                        enabled: true,
                        //searchEnabled: true,
                        chipDecoration: ChipDecoration(
                          backgroundColor: cs.primary,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                        ),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Payment Methods',
                          hintStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Icon(CupertinoIcons.money_dollar),
                          ),
                          showClearIcon: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(color: cs.onSurface),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        dropdownDecoration: DropdownDecoration(
                          marginTop: 2,
                          maxHeight: 500,
                          header: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Select payment method',
                              textAlign: TextAlign.start,
                              style: tt.titleSmall!.copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                        dropdownItemDecoration: DropdownItemDecoration(
                          backgroundColor: Colors.grey.shade300,
                          selectedBackgroundColor: Colors.grey.shade300,
                          textColor: Colors.black87,
                          selectedTextColor: Colors.black87,
                          selectedIcon: Icon(Icons.check_box, color: cs.primary),
                          disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a payment method';
                          }
                          return null;
                        },
                        onSelectionChange: (selectedItems) {
                          if (controller.buttonPressed) controller.formKey.currentState!.validate();
                          print("OnSelectionChange: $selectedItems");
                          controller.toggleFields();
                        },
                      ),
                    ),
              controller.isLoadingVehicle //todo: add refresh button
                  ? SpinKitThreeBounce(color: cs.primary, size: 20)
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MultiDropdown<VehicleTypeModel>(
                        items: controller.vehicleTypes
                            .map(
                              (vehicleType) => DropdownItem(
                                label: vehicleType.type,
                                value: vehicleType,
                              ),
                            )
                            .toList(),
                        controller: controller.vehicleTypeController,
                        enabled: true,
                        //searchEnabled: true,
                        chipDecoration: ChipDecoration(
                          backgroundColor: cs.primary,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                        ),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Vehicles types',
                          hintStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Icon(Icons.fire_truck),
                          ),
                          showClearIcon: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(color: cs.onSurface),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        dropdownDecoration: DropdownDecoration(
                          marginTop: 2,
                          maxHeight: 500,
                          header: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Select vehicle types',
                              textAlign: TextAlign.start,
                              style: tt.titleSmall!.copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                        dropdownItemDecoration: DropdownItemDecoration(
                          backgroundColor: Colors.grey.shade300,
                          selectedBackgroundColor: Colors.grey.shade300,
                          textColor: Colors.black87,
                          selectedTextColor: Colors.black87,
                          selectedIcon: Icon(Icons.check_box, color: cs.primary),
                          disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a vehicle type';
                          }
                          return null;
                        },
                        onSelectionChange: (selectedItems) {
                          if (controller.buttonPressed) controller.formKey.currentState!.validate();
                          print("OnSelectionChange: $selectedItems");
                        },
                      ),
                    ),
              Visibility(
                visible: controller.isBankSelected,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: InputField(
                    controller: controller.accountName,
                    label: "bank account name",
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.none,
                    prefixIcon: Icons.account_balance,
                    validator: (val) {
                      return validateInput(controller.accountName.text, 1, 1000, ""); //todo check constraints
                    },
                    onChanged: (val) {
                      if (controller.isBankSelected && controller.buttonPressed) {
                        controller.formKey.currentState!.validate();
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CheckboxListTile(
                  value: controller.coveredCar,
                  onChanged: (val) {
                    controller.toggleCoveredCar();
                  },
                  title: Text(
                    "covered car required",
                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  ),
                  secondary: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      CupertinoIcons.car,
                      color: cs.onSurface,
                      size: 22,
                    ),
                  ),
                  // shape: RoundedRectangleBorder(
                  //   side: BorderSide(width: 1.5, color: cs.onSurface),
                  //   borderRadius: BorderRadius.circular(32),
                  // ),
                ),
              ),
              //todo: add drop down for vehicle types and payment methods
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
