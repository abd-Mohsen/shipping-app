import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/governorate_model.dart';

class GovernorateSelector extends StatelessWidget {
  final GovernorateModel? selectedItem;
  final List<GovernorateModel> items;
  final void Function(GovernorateModel?) onChanged;

  const GovernorateSelector({
    super.key,
    this.selectedItem,
    required this.items,
    required this.onChanged,
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
          color: color ?? (Get.isDarkMode ? cs.surface : Colors.grey.shade400), // Fake shadow color
        ),
      );
    }

    return DropdownSearch<GovernorateModel>(
      validator: (type) {
        if (type == null) return "you must select a governorate".tr;
        return null;
      },
      selectedItem: selectedItem,
      compareFn: (type1, type2) => type1.id == type2.id,
      popupProps: PopupProps.menu(
        constraints: BoxConstraints(maxHeight: 200),
        showSearchBox: false,
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
        searchFieldProps: TextFieldProps(
          style: tt.titleSmall!.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            fillColor: Colors.white70,
            hintText: "governorate name".tr,
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
          filled: true,
          fillColor: cs.secondaryContainer,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Icon(Icons.location_city, color: cs.primaryContainer),
          ),
          labelText: "selected governorate".tr,
          labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: border(width: 1.5),
          focusedBorder: border(width: 2),
          errorBorder: border(color: cs.error, width: 1.5),
          focusedErrorBorder: border(color: cs.error, width: 2),
        ),
      ),
      items: (filter, infiniteScrollProps) => items,
      itemAsString: (GovernorateModel governorate) => governorate.name,
      onChanged: onChanged,
      //enabled: !con.enabled,
    );
  }
}
