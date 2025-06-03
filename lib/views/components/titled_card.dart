import 'package:flutter/material.dart';

class TitledCard extends StatelessWidget {
  final String title;
  final Widget content;
  final double? radius;
  const TitledCard({super.key, required this.title, required this.content, this.radius});

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
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 2, // Soften the shadow
            spreadRadius: 1, // Extend the shadow
            offset: Offset(1, 1), // Shadow direction (x, y)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Text(
              title,
              style: tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: cs.onSurface.withOpacity(0.2)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 8),
            child: content,
          ),
        ],
      ),
    );
  }
}
