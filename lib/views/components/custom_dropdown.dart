import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    this.icon,
    required this.title,
    required this.items,
    required this.onSelect,
    required this.selectedValue,
  });

  final IconData? icon;
  final String title;
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
        child: ListTile(
          leading: icon != null
              ? Icon(
                  icon,
                  size: 30,
                  color: cs.primary,
                )
              : null,
          title: Text(
            title,
            style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.8), overflow: TextOverflow.ellipsis),
          ),
          trailing: DropdownButton<String>(
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
            dropdownColor: Colors.white, // Background color of dropdown
            menuMaxHeight: 300, // Limit dropdown height
            alignment: Alignment.bottomCenter, // Align menu to bottom
            borderRadius: BorderRadius.circular(20),
            //padding: const EdgeInsets.only(top: 100.0),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: cs.surface),
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: cs.secondary,
        ),
      ),
    );
  }
}
