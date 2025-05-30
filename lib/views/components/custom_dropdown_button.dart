import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.onSelect,
    required this.selectedValue,
  });

  final String selectedValue;
  final List<String> items;
  final void Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: cs.surface),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DropdownButton<String>(
          value: selectedValue,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: tt.titleSmall!.copyWith(
                      overflow: TextOverflow.ellipsis,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onSelect,
          style: tt.titleLarge!.copyWith(color: cs.onSurface),
          dropdownColor: cs.surface, // Background color of dropdown
          menuMaxHeight: 300, // Limit dropdown height
          alignment: Alignment.bottomCenter, // Align menu to bottom
          borderRadius: BorderRadius.circular(20),
          //padding: const EdgeInsets.only(top: 100.0),
        ),
      ),
    );
  }
}
