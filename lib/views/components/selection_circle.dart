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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: LinearGradient(
                  colors: [cs.primary, Color.lerp(cs.primary, Colors.white, 0.4)!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1],
                ),
              ),
              child: Icon(
                iconData,
                color: cs.onPrimary,
                size: 23,
              ),
              //backgroundColor: Colors.redAccent,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: isSelected
                  ? tt.labelSmall!.copyWith(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 10)
                  : tt.labelSmall!.copyWith(color: cs.onSurface, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
