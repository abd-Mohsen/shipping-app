import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MyLoadingAnimation extends StatelessWidget {
  final String file;
  final String title;
  final double? height;
  final double? paddingValue;
  final bool showAnimation;
  const MyLoadingAnimation({
    super.key,
    this.file = "simple truck2",
    this.title = "no data, pull down to refresh",
    this.height,
    this.paddingValue,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          if (showAnimation) Lottie.asset("assets/animations/$file.json", height: height ?? 200),
          Padding(
            padding: EdgeInsets.all(paddingValue ?? 24),
            child: Center(
              child: Text(
                title.tr,
                style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
