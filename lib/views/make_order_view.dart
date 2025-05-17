import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/date_selector.dart';
import 'package:shipment/views/components/input_field.dart';
import 'package:shipment/views/components/map_selector.dart';
import 'package:shipment/views/components/time_selector.dart';

import '../controllers/make_order_controller.dart';
import 'components/auth_field.dart';

//todo: refactor to use it as edit page
class MakeOrderView extends StatelessWidget {
  const MakeOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    CustomerHomeController cHC = Get.find();
    MakeOrderController mOC = Get.put(MakeOrderController(customerHomeController: cHC));

    OutlineInputBorder border({Color? color, double width = 0.5}) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: width,
          color: color ?? (Get.isDarkMode ? cs.surface : Colors.grey.shade300), // Fake shadow color
        ),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.secondaryContainer,
        title: Text(
          'make an order'.tr,
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          //
        ],
      ),
      body: GetBuilder<MakeOrderController>(
        builder: (controller) {
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
                  makeOrderController: mOC,
                  start: true,
                  address: controller.sourceAddress?.toString() ?? "select location".tr,
                  onClose: () {
                    controller.calculateStartAddress();
                  },
                  isLoading: controller.isLoadingSelect1,
                  source: "make",
                ),
                MapSelector(
                  mapController: controller.mapController2,
                  makeOrderController: mOC,
                  start: false,
                  address: controller.targetAddress?.toString() ?? "select location".tr,
                  onClose: () {
                    controller.calculateTargetAddress();
                  },
                  isLoading: controller.isLoadingSelect2,
                  source: "make",
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: controller.isLoadingVehicle
                      ? SpinKitThreeBounce(color: cs.primary, size: 20)
                      : DropdownSearch<VehicleTypeModel>(
                          validator: (type) {
                            if (type == null) return "you must select a type".tr;
                            return null;
                          },
                          compareFn: (type1, type2) => type1.id == type2.id,
                          popupProps: PopupProps.menu(
                            showSearchBox: false,
                            constraints: BoxConstraints(maxHeight: 300), // Makes the dropdown shorter
                            menuProps: MenuProps(
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(10), // Only round bottom corners
                                  top: Radius.circular(10), // Only round bottom corners
                                ),
                              ),
                              backgroundColor: cs.surface,
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            baseStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Icon(
                                  Icons.fire_truck,
                                  color: cs.primary,
                                ),
                              ),
                              filled: true,
                              fillColor: cs.secondaryContainer,
                              labelText: "required vehicle type".tr,
                              labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              enabledBorder: border(width: 1.5),
                              focusedBorder: border(width: 2),
                              errorBorder: border(color: cs.error, width: 1.5),
                              focusedErrorBorder: border(color: cs.error, width: 2),
                            ),
                          ),
                          items: (filter, infiniteScrollProps) => controller.vehicleTypes,
                          itemAsString: (VehicleTypeModel type) => type.type,
                          onChanged: (VehicleTypeModel? type) async {
                            controller.selectVehicleType(type);
                            await Future.delayed(const Duration(milliseconds: 1000));
                            if (controller.buttonPressed) controller.formKey.currentState!.validate();
                          },
                          //enabled: !con.enabled,
                        ),
                ),
                InputField(
                  controller: controller.description,
                  label: "description".tr,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  prefixIcon: Icons.text_snippet,
                  validator: (val) {
                    return validateInput(controller.description.text, 4, 1000, "text");
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                InputField(
                  controller: controller.weight,
                  label: "weight with unit".tr,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.monitor_weight,
                  validator: (val) {
                    return validateInput(controller.weight.text, 1, 100, "");
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                InputField(
                  controller: controller.price,
                  label: "expected price".tr,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.attach_money,
                  validator: (val) {
                    return validateInput(controller.price.text, 1, 18, "", wholeNumber: true);
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: controller.isLoadingPayment //todo: load again after failing, do it also in vehicle type
                      ? SpinKitThreeBounce(color: cs.primary, size: 20)
                      : MultiDropdown<PaymentMethodModel>(
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
                            backgroundColor: cs.secondaryContainer,
                            hintText: 'payment methods'.tr,
                            hintStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
                              child: Icon(
                                CupertinoIcons.money_dollar,
                                color: cs.primary,
                              ),
                            ),
                            showClearIcon: false,
                            border: border(width: 1.5),
                            focusedBorder: border(width: 2),
                            errorBorder: border(color: cs.error, width: 1.5),
                          ),
                          dropdownDecoration: DropdownDecoration(
                            elevation: 8,
                            marginTop: -4,
                            maxHeight: 500,
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            // filled: true,
                            // fillColor: cs.secondary,
                            backgroundColor: cs.secondaryContainer,
                            disabledBackgroundColor: cs.secondaryContainer,
                            selectedBackgroundColor: cs.secondaryContainer,
                            textColor: cs.onSurface,
                            selectedTextColor: cs.onSurface,
                            selectedIcon: Icon(Icons.check_box, color: cs.primary),
                            //disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'select payment method'.tr;
                            }
                            return null;
                          },
                          onSelectionChange: (selectedItems) {
                            if (controller.buttonPressed) controller.formKey.currentState!.validate();
                            print("OnSelectionChange: $selectedItems");
                            //controller.toggleFields();
                          },
                        ),
                ),
                InputField(
                  controller: controller.otherInfo,
                  label: "other info (optional)".tr,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  prefixIcon: Icons.note,
                  validator: (val) {
                    return validateInput(
                      controller.otherInfo.text,
                      0,
                      10000,
                      "",
                      canBeEmpty: true,
                    );
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          color: cs.secondaryContainer,
                          elevation: 3,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child:
                                  DateSelector(date: controller.selectedDate, selectDateCallback: controller.setDate)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          color: cs.secondaryContainer,
                          elevation: 3,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child:
                                  TimeSelector(time: controller.selectedTime, selectTimeCallback: controller.setTime)),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: controller.isLoadingExtra
                      ? SpinKitThreeBounce(color: cs.primary, size: 20)
                      : ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              "extra options".tr,
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            ),
                          ),
                          children: List.generate(
                            controller.extraInfo.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CheckboxListTile(
                                value: controller.extraInfoSelection[i],
                                onChanged: (val) {
                                  controller.toggleExtraInfo(i, val!);
                                },
                                title: Text(
                                  controller.extraInfo[i],
                                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                CustomButton(
                  onTap: () {
                    //print(GetStorage().read("token"));
                    controller.makeOrder();
                  },
                  child: Center(
                    child: controller.isLoading
                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                        : Text(
                            "make order".tr.toUpperCase(),
                            style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
