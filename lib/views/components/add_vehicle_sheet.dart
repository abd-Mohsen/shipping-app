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

    OutlineInputBorder border({Color? color, double width = 0.5}) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: width,
          color: color ?? (Get.isDarkMode ? cs.surface : Colors.grey.shade300), // Fake shadow color
        ),
      );
    }

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
                Padding(
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
