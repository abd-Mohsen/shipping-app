import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TempMapPage extends StatelessWidget {
  final Widget map;
  const TempMapPage({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    //TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          map,
          Positioned(
            top: 50,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2), // Shadow color
                    blurRadius: 3, // Soften the shadow
                    spreadRadius: 1.5, // Extend the shadow
                    offset: const Offset(1, 1), // Shadow direction (x, y)
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: cs.onSecondaryContainer,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
