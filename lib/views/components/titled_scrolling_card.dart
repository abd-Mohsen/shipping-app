import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitledScrollingCard extends StatelessWidget {
  final String title;
  final Widget content;
  final void Function()? onClickSeeAll;
  final bool isEmpty;
  final double? radius;
  const TitledScrollingCard({
    super.key,
    required this.title,
    required this.content,
    this.onClickSeeAll,
    required this.isEmpty,
    this.radius,
  });

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
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    title,
                    style: tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                  ),
                ),
                if (onClickSeeAll != null)
                  GestureDetector(
                    onTap: onClickSeeAll,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "see all".tr,
                        style: tt.labelSmall!.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: cs.onSurface.withOpacity(0.2)),
            ),
            Expanded(
                child: isEmpty
                    ? Center(
                        child: ListView(
                          shrinkWrap: true,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Lottie.asset("assets/animations/simple truck.json", height: 200),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Center(
                                child: Text(
                                  "no data, pull down to refresh".tr,
                                  style: tt.titleSmall!.copyWith(
                                    color: cs.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 72),
                          ],
                        ),
                      )
                    : content),
          ],
        ),
      ),
    );
  }
}
