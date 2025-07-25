import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterButton extends StatelessWidget {
  final bool showBadge;
  final Widget sheet;
  const FilterButton({super.key, required this.showBadge, required this.sheet});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return badges.Badge(
      showBadge: showBadge,
      position: badges.BadgePosition.topStart(
        top: -3, // Negative value moves it up
        start: -3, // Negative value moves it left
      ),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.circle,
        badgeColor: const Color(0xff00ff00),
        borderRadius: BorderRadius.circular(4),
      ),
      child: GestureDetector(
        onTap: () {
          showMaterialModalBottomSheet(
            context: context,
            //isDismissible: false,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.black.withValues(alpha: 0.5),
            enableDrag: true,
            builder: (context) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: sheet,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cs.primary,
          ),
          child: FaIcon(
            FontAwesomeIcons.sliders,
            color: cs.onPrimary,
            size: 20,
          ),
        ),
      ),
    );
    ;
  }
}
