import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onTap;
  final Widget child;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }
}
