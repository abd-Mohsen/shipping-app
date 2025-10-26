import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class MyShowcase extends StatelessWidget {
  final GlobalKey globalKey;
  final Widget child;
  final String description;
  final bool enabled;
  final void Function()? onClick;

  const MyShowcase({
    super.key,
    required this.globalKey,
    required this.child,
    required this.description,
    required this.enabled,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return (enabled)
        ? Showcase(
            key: globalKey,
            description: description,
            // textColor: cs.onSurface,
            // tooltipBackgroundColor: cs.surface,
            onBarrierClick: onClick,
            child: child,
          )
        : child;
  }
}
