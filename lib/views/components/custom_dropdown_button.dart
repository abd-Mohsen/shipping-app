import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.onSelect,
    required this.selectedValue,
  });

  final T? selectedValue;
  final List<T> items;
  final void Function(T?) onSelect;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: cs.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            width: 1.5,
            color: Get.isDarkMode ? cs.surface : Colors.grey.shade300, // Fake shadow color
          ),
        ),
        child: DropdownButton<T>(
          value: selectedValue,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: tt.labelMedium!.copyWith(
                      overflow: TextOverflow.ellipsis,
                      color: cs.onSurface,
                    ),
                    maxLines: 2,
                  ),
                ),
              )
              .toList(),
          onChanged: onSelect,
          style: tt.titleLarge!.copyWith(color: cs.onSurface),
          dropdownColor: cs.surface,
          menuMaxHeight: 300,
          alignment: Alignment.bottomCenter,
          // Keep only one borderRadius declaration - either here or in Material
          borderRadius: BorderRadius.circular(10),
          isExpanded: true, // Recommended for proper width
          underline: const SizedBox(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
