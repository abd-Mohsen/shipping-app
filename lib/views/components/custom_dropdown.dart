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
                    style: tt.titleSmall!.copyWith(overflow: TextOverflow.ellipsis, color: cs.onSurface),
                  ),
                ),
              )
              .toList(),
          onChanged: onSelect,
          style: tt.titleLarge!.copyWith(color: cs.onSurface),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: cs.onBackground),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
