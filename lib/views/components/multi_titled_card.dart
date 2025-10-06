import 'package:flutter/material.dart';

class MultiTitledCard extends StatelessWidget {
  final List<String> titles;
  final List<Widget> contents;
  final double? radius;
  const MultiTitledCard({super.key, required this.titles, required this.contents, this.radius});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2), // Shadow color
            blurRadius: 2, // Soften the shadow
            spreadRadius: 1, // Extend the shadow
            offset: const Offset(1, 1), // Shadow direction (x, y)
          ),
        ],
      ),
      child: Column(
          children: List.generate(
        titles.length,
        (i) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                titles[i],
                style: tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: cs.onSurface.withValues(alpha: 0.2)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8),
              child: contents[i],
            ),
          ],
        ),
      )),
    );
  }
}
