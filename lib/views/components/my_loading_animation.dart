import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MyLoadingAnimation extends StatelessWidget {
  final String file;
  const MyLoadingAnimation({super.key, this.file = "simple truck"});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Lottie.asset("assets/animations/$file.json", height: 200),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                "no data, pull down to refresh".tr,
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
