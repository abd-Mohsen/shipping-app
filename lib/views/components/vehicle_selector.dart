import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/vehicle_model.dart';

class VehicleSelector extends StatelessWidget {
  final VehicleModel? selectedItem;
  final List<VehicleModel> items;
  final void Function(VehicleModel?) onChanged;
  const VehicleSelector({super.key, this.selectedItem, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return DropdownSearch<VehicleModel>(
      selectedItem: selectedItem,
      validator: (type) {
        if (type == null) return "you must select vehicle".tr;
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
            hintText: "vehicle".tr,
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
            child: Icon(Icons.local_shipping),
          ),
          labelText: "required vehicle".tr,
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
      items: (filter, infiniteScrollProps) => items,
      itemAsString: (VehicleModel v) => v.toString(),
      onChanged: onChanged,
      //enabled: !con.enabled,
    );
  }
}
