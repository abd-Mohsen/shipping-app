import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/input_field.dart';
import '../../controllers/my_vehicles_controller.dart';
import '../../models/vehicle_type_model.dart';
import 'auth_field.dart';
import 'id_image_selector.dart';

class AddVehicleSheet extends StatelessWidget {
  const AddVehicleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MyVehiclesController mVC = Get.find();
    return GetBuilder<MyVehiclesController>(
      builder: (controller) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                InputField(
                  controller: controller.vehicleOwner,
                  label: "owner name".tr,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person,
                  validator: (val) {
                    return validateInput(controller.vehicleOwner.text, 0, 100, "");
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                InputField(
                  controller: controller.licensePlate,
                  label: "license Plate".tr,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.tag,
                  validator: (val) {
                    return validateInput(controller.licensePlate.text, 0, 100, "", wholeNumber: true);
                  },
                  onChanged: (val) {
                    if (controller.buttonPressed) controller.formKey.currentState!.validate();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: cs.onSurface.withOpacity(0.7),
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IdImageSelector(
                      title: "registration".tr,
                      isSubmitted: controller.registration != null,
                      image: controller.registration,
                      onTapCamera: () {
                        controller.pickImage("camera");
                      },
                      onTapGallery: () {
                        controller.pickImage("gallery");
                      },
                    ),
                  ),
                ),
                CustomButton(
                  onTap: () {
                    controller.submit();
                  },
                  child: Center(
                    child: controller.isLoadingSubmit
                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                        : Text(
                            "add".tr.toUpperCase(),
                            style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
