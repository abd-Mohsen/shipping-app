import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/vehicle_type_model.dart';

class VehicleTypeSelector extends StatelessWidget {
  final VehicleTypeModel? selectedItem;
  final List<VehicleTypeModel> items;
  final void Function(VehicleTypeModel?) onChanged;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final EdgeInsetsGeometry? padding;

  const VehicleTypeSelector({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.floatingLabelBehavior,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    OutlineInputBorder border({Color? color, double width = 0.5}) {
      return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: width,
          color: color ?? (Get.isDarkMode ? cs.surface : Colors.grey.shade300), // Fake shadow color
        ),
      );
    }

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: DropdownSearch<VehicleTypeModel>(
        selectedItem: selectedItem,
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Icon(
                Icons.fire_truck,
                color: cs.primary,
              ),
            ),
            filled: true,
            fillColor: cs.secondaryContainer,
            labelText: "required vehicle type".tr,
            labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
            floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.never,
            enabledBorder: border(width: 1.5),
            focusedBorder: border(width: 2),
            errorBorder: border(color: cs.error, width: 1.5),
            focusedErrorBorder: border(color: cs.error, width: 2),
          ),
        ),
        items: (filter, infiniteScrollProps) => items,
        itemAsString: (VehicleTypeModel type) => type.type,
        onChanged: onChanged,
        //enabled: !con.enabled,
      ),
    );
  }
}
