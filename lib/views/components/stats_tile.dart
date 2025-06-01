import 'package:flutter/material.dart';

class StatsTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;
  final double? iconSize;

  const StatsTile({
    super.key,
    required this.title,
    required this.value,
    required this.iconData,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 1, // Soften the shadow
            spreadRadius: 0.1, // Extend the shadow
            //offset: const Offset(2, 2), // Shadow direction (x, y)
          ),
        ],
        color: cs.secondaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [cs.primary, Colors.black], // Your gradient colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 1],
              ).createShader(bounds);
            },
            child: Icon(iconData, size: iconSize ?? 32),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: tt.headlineMedium!.copyWith(color: cs.onSurface),
          ),
          Text(
            title,
            style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
