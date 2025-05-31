import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/vehicle_type_selector.dart';

import '../../controllers/filter_controller.dart';
import '../../models/currency_model.dart';
import '../../models/vehicle_type_model.dart';
import 'custom_dropdown_button.dart';
import 'governorate_selector.dart';

class FilterSheet extends StatelessWidget {
  final bool showGovernorate;
  final bool showPrice;
  final bool showVehicleType;
  final void Function() onConfirm;

  const FilterSheet({
    super.key,
    required this.showGovernorate,
    required this.showPrice,
    required this.showVehicleType,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: GetBuilder<FilterController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                children: [
                  if (showVehicleType)
                    controller.isLoadingInfo
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SpinKitThreeBounce(color: cs.primary, size: 20),
                          )
                        : VehicleTypeSelector(
                            selectedItem: controller.selectedVehicleType,
                            items: controller.vehicleTypes,
                            onChanged: (VehicleTypeModel? type) async {
                              controller.selectVehicleType(type);
                              await Future.delayed(const Duration(milliseconds: 1000));
                            },
                          ),
                  //
                  if (showGovernorate)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        controller.isLoadingGovernorates
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SpinKitThreeBounce(color: cs.primary, size: 20),
                              )
                            : GovernorateSelector(
                                selectedItem: controller.selectedGovernorate,
                                items: controller.governorates,
                                onChanged: (g) {
                                  controller.setGovernorate(g);
                                },
                              ),
                      ],
                    ),
                  if (showPrice)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "min price".tr,
                              style: tt.labelSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "max price".tr,
                              style: tt.labelSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbColor: cs.primary,
                            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 6.5),
                            trackHeight: 0.5,
                          ),
                          child: RangeSlider(
                            values: RangeValues(
                              controller.minPrice,
                              controller.maxPrice,
                            ),
                            onChanged: (r) {
                              controller.setPriceRange(r.start, r.end);
                            },
                            min: controller.sliderMinPrice,
                            max: controller.sliderMaxPrice,
                            divisions: 100000000,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                controller.minPrice.floor().toString() + (controller.selectedCurrency?.symbol ?? ""),
                                style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: controller.isLoadingInfo
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: SpinKitThreeBounce(color: cs.primary, size: 20),
                                    )
                                  : CustomDropdownButton<CurrencyModel>(
                                      items: controller.currencies,
                                      onSelect: (c) {
                                        controller.selectCurrency(c);
                                      },
                                      selectedValue: controller.selectedCurrency,
                                    ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                controller.maxPrice.floor().toString() + (controller.selectedCurrency?.symbol ?? ""),
                                style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  controller.clearFilters();
                },
                child: Text(
                  "clear filters".tr,
                  style: tt.titleSmall!.copyWith(
                    color: cs.onSurface.withOpacity(0.7),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onConfirm,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "ok".tr,
                    style: tt.labelMedium!.copyWith(color: cs.onPrimary),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
