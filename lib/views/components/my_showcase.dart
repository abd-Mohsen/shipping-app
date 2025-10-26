import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class MyShowcase extends StatelessWidget {
  final GlobalKey globalKey;
  final Widget child;
  final String description;
  final bool enabled;

  const MyShowcase({
    super.key,
    required this.globalKey,
    required this.child,
    required this.description,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return (enabled) ? Showcase(key: globalKey, description: description, child: child) : child;
  }
}
