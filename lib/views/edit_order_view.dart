import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/edit_order_controller.dart';
import 'package:shipment/models/order_model.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/input_field.dart';
import 'package:shipment/views/components/map_selector.dart';
import 'components/auth_field.dart';
import 'components/date_selector.dart';
import 'components/time_selector.dart';

class EditOrderView extends StatelessWidget {
  final OrderModel order;
  const EditOrderView({super.key, required this.order});

  //todo: make ui like make_order_view
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    CustomerHomeController cHC = Get.find();
    EditOrderController eOC = Get.put(EditOrderController(customerHomeController: cHC, order: order));
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'edit order'.tr.toUpperCase(),
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          //
        ],
      ),
      body: GetBuilder<EditOrderController>(
        builder: (controller) {
          return Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                //   child: SvgPicture.asset("assets/images/make_order.svg", height: 200),
                // ),
                MapSelector(
                  mapController: controller.mapController1,
                  editOrderController: eOC,
                  start: true,
                  address: controller.startAddress?.toString() ?? "select location".tr,
                  onClose: () {
                    controller.calculateStartAddress();
                  },
                  isLoading: controller.isLoadingSelect1,
                  source: "edit",
                ),
                MapSelector(
                  mapController: controller.mapController2,
                  editOrderController: eOC,
                  start: false,
                  address: controller.endAddress?.toString() ?? "select location".tr,
                  onClose: () {
                    controller.calculateTargetAddress();
                  },
                  isLoading: controller.isLoadingSelect2,
                  source: "edit",
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: controller.isLoadingVehicle
                      ? SpinKitThreeBounce(color: cs.primary, size: 20)
                      : DropdownSearch<VehicleTypeModel>(
                          selectedItem: controller.selectedVehicleType,
                          validator: (type) {
                            if (type == null) return "you must select a type".tr;
                            return null;
                          },
                          compareFn: (type1, type2) => type1.id == type2.id,
                          popupProps: PopupProps.menu(
                            showSearchBox: false,
                            menuProps: MenuProps(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            searchFieldProps: TextFieldProps(
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                              decoration: InputDecoration(
                                fillColor: Colors.white70,
                                hintText: "vehicle type".tr,
                                prefix: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(Icons.search, color: cs.onSurface),
                                ),
                              ),
                            ),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            baseStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                            decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Icon(Icons.fire_truck),
                              ),
                              labelText: "required vehicle type".tr,
                              labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                  width: .5,
                                  color: cs.onSurface,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: cs.onSurface,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: cs.error,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: cs.error,
                                ),
                              ),
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
                            hintText: 'payment methods'.tr,
                            hintStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
                              child: Icon(CupertinoIcons.money_dollar),
                            ),
                            showClearIcon: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(color: cs.onSurface, width: 0.5),
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
                                'select payment method'.tr,
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
                order.dateTime.isBefore(DateTime.now())
                    ? Badge(
                        smallSize: 10,
                        backgroundColor: const Color(0xff00ff00),
                        alignment: Alignment.centerRight,
                        child: DateSelector(date: controller.selectedDate, selectDateCallback: controller.setDate),
                      )
                    : DateSelector(date: controller.selectedDate, selectDateCallback: controller.setDate),
                TimeSelector(time: controller.selectedTime, selectTimeCallback: controller.setTime),
                ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      "extra options".tr,
                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CheckboxListTile(
                        value: controller.coveredCar,
                        onChanged: (val) {
                          controller.toggleCoveredCar();
                        },
                        title: Text(
                          "covered car required".tr,
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
                      ),
                    ),
                    //todo: بكرات تحزيم
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CheckboxListTile(
                        value: controller.coveredCar,
                        onChanged: (val) {
                          controller.toggleCoveredCar();
                        },
                        title: Text(
                          "cables required".tr,
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
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onTap: () {
                    controller.editOrder();
                  },
                  child: Center(
                    child: controller.isLoading
                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                        : Text(
                            "edit order".tr.toUpperCase(),
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
