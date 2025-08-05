import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/employee_model.dart';

class EmployeeSelector extends StatelessWidget {
  final EmployeeModel? selectedItem;
  final List<EmployeeModel> items;
  final void Function(EmployeeModel?) onChanged;

  const EmployeeSelector({super.key, this.selectedItem, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return DropdownSearch<EmployeeModel>(
      selectedItem: selectedItem,
      validator: (type) {
        if (type == null) return "you must select an employee".tr;
        return null;
      },
      compareFn: (type1, type2) => type1.id == type2.id,
      popupProps: PopupProps.menu(
        constraints: const BoxConstraints(maxHeight: 200),
        emptyBuilder: (context, searchEntry) {
          return Center(
            child: Text(
              "no data".tr,
              style: tt.titleSmall!.copyWith(color: cs.onSurface),
            ),
          );
        },
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
            hintText: "employee".tr,
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
            child: Icon(Icons.person),
          ),
          labelText: "required employee".tr,
          labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
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
      itemAsString: (EmployeeModel e) =>
          e.user.toString() + "\n" + e.vehicle!.vehicleType + " #" + e.vehicle!.vehicleRegistrationNumber,
      onChanged: onChanged,
      // dropdownBuilder: (_, e) => ListTile(
      //   title: Text(
      //     e!.user.toString(),
      //     style: tt.titleSmall!.copyWith(color: cs.onSurface),
      //   ),
      // ),
      //enabled: !con.enabled,
    );
  }
}
