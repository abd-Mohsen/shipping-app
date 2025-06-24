import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final Color? color;
  final bool? isShort;
  final bool? isGradiant;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.isShort,
    this.isGradiant,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: elevation ?? 0,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: color ?? cs.primary,
              borderRadius: BorderRadius.circular(10),
              gradient: ((isGradiant ?? false) && color != Colors.grey)
                  ? LinearGradient(
                      colors: [Color.lerp(cs.primary, Colors.white, 0.25)!, cs.primary],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 1],
                    )
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: (isShort ?? false) ? 12 : 14.0),
              child: SizedBox(
                width: double.infinity,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
