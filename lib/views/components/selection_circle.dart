import 'package:flutter/material.dart';

class SelectionCircle extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool isSelected;
  final void Function() onTap;

  const SelectionCircle({
    super.key,
    required this.iconData,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Color.lerp(cs.primary, Colors.white, 0.05),
              radius: 24,
              child: Icon(
                iconData,
                color: cs.onPrimary,
              ),
              //backgroundColor: Colors.redAccent,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: isSelected
                  ? tt.titleSmall!.copyWith(color: cs.primary, fontWeight: FontWeight.bold)
                  : tt.titleSmall!.copyWith(color: cs.onSurface),
            )
          ],
        ),
      ),
    );
  }
}
