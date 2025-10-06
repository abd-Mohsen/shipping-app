import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/input_field.dart';
import 'package:shipment/views/components/vehicle_type_selector.dart';
import '../../controllers/my_vehicles_controller.dart';
import '../../models/vehicle_model.dart';
import '../../models/vehicle_type_model.dart';
import 'package:badges/badges.dart' as badges;
import 'auth_field.dart';
import 'governorate_selector.dart';
import 'id_image_selector.dart';
import 'package:pinput/pinput.dart';

// i get an error if i redirect to vehicle page
// so fucking slow
class AddVehicleSheet extends StatelessWidget {
  final VehicleModel? vehicle;
  const AddVehicleSheet({super.key, this.vehicle});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    //MyVehiclesController mVC = Get.find();

    return GetBuilder<MyVehiclesController>(
      builder: (controller) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.6,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      children: [
                        InputField(
                          controller: controller.vehicleOwner,
                          label: "owner name".tr,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.person,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          validator: (val) {
                            return validateInput(controller.vehicleOwner.text, 0, 100, "");
                          },
                          onChanged: (val) {
                            if (controller.buttonPressed) controller.formKey.currentState!.validate();
                          },
                        ),
                        // InputField(
                        //   controller: controller.licensePlate,
                        //   label: "license plate".tr,
                        //   keyboardType: TextInputType.number,
                        //   textInputAction: TextInputAction.next,
                        //   prefixIcon: Icons.tag,
                        //   floatingLabelBehavior: FloatingLabelBehavior.auto,
                        //   validator: (val) {
                        //     return validateInput(controller.licensePlate.text, 0, 100, "", wholeNumber: true);
                        //   },
                        //   onChanged: (val) {
                        //     if (controller.buttonPressed) controller.formKey.currentState!.validate();
                        //   },
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, top: 4),
                          child: CheckboxListTile(
                            activeColor: cs.primary,
                            checkColor: cs.onPrimary,
                            value: controller.isOldPlate,
                            onChanged: (val) {
                              controller.setIsOldPlate(val!);
                            },
                            title: Text(
                              "old license plate".tr,
                              style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "license plate".tr,
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            ),
                            const SizedBox(height: 8),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Pinput(
                                controller: controller.licensePlate,
                                length: controller.isOldPlate ? 6 : 7,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  // Remove dash just in case it’s part of the value
                                  final cleanValue = value?.replaceAll('-', '') ?? '';

                                  // Check if the number of digits matches expected length
                                  final expectedLength = controller.isOldPlate ? 6 : 7;

                                  if (cleanValue.length < expectedLength) {
                                    return 'Please fill all digits'.tr;
                                  }
                                  return null; // ✅ Valid
                                },
                                errorTextStyle: TextStyle(
                                  fontSize: 12, // smaller text
                                  color: cs.error,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                ),
                                separatorBuilder: (index) {
                                  // Show dash only if it's a new code (7 digits)
                                  if (!controller.isOldPlate && index == 2) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                      child: Text(
                                        "-",
                                        style: tt.titleMedium!.copyWith(
                                          color: cs.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox(width: 6);
                                },
                                defaultPinTheme: PinTheme(
                                  width: 36,
                                  height: 40,
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: cs.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cs.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: cs.outlineVariant),
                                  ),
                                ),
                                focusedPinTheme: PinTheme(
                                  width: 40,
                                  height: 48,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: cs.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: BoxDecoration(
                                    color: cs.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: cs.primary, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),

                        controller.isLoadingGovernorates
                            ? SpinKitThreeBounce(color: cs.primary, size: 20)
                            : Visibility(
                                visible: controller.isOldPlate,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: GovernorateSelector(
                                    selectedItem: controller.selectedGovernorate,
                                    items: controller.governorates,
                                    onChanged: (g) {
                                      controller.setGovernorate(g);
                                    },
                                    color: cs.primary,
                                  ),
                                ),
                              ),

                        controller.isLoadingVehicle
                            ? SpinKitThreeBounce(color: cs.primary, size: 20)
                            : VehicleTypeSelector(
                                selectedItem: controller.selectedVehicleType,
                                items: controller.vehicleTypes,
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                onChanged: (VehicleTypeModel? type) async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  controller.selectVehicleType(type);
                                  await Future.delayed(const Duration(milliseconds: 1000));
                                  if (controller.buttonPressed) controller.formKey.currentState!.validate();
                                },
                              ),
                        controller.isLoadingImage
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: SpinKitThreeBounce(color: cs.onSurface, size: 20),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: badges.Badge(
                                  showBadge: vehicle != null && vehicle!.registrationStatus == "refused",
                                  position: badges.BadgePosition.topStart(
                                    top: 0, // Negative value moves it up
                                    start: 0, // Negative value moves it left
                                  ),
                                  badgeStyle: badges.BadgeStyle(
                                    shape: badges.BadgeShape.circle,
                                    badgeColor: const Color(0xff00ff00),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: IdImageSelector(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    title: "registration".tr,
                                    isSubmitted: controller.registration != null,
                                    image: controller.registration,
                                    onTapCamera: () {
                                      controller.pickImage("camera");
                                    },
                                    onTapGallery: () {
                                      controller.pickImage("gallery");
                                    },
                                    uploadStatus: vehicle?.registrationStatus,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                if (!controller.pickedAnImage && vehicle != null && vehicle!.registrationStatus == "refused")
                  Center(
                    child: Text(
                      "your register is refused, choose another image".tr,
                      style: tt.titleSmall!.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: CustomButton(
                    onTap: () {
                      print(vehicle);
                      controller.submit(vehicle?.id);
                    },
                    child: Center(
                      child: controller.isLoadingSubmit
                          ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                          : Text(
                              vehicle != null ? "edit".tr.toUpperCase() : "add".tr.toUpperCase(),
                              style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                            ),
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
