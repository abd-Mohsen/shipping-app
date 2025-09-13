import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/my_loading_animation.dart';

class TitledScrollingCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final void Function()? onClickSeeAll;
  final bool isEmpty;
  final double? radius;
  final int itemCount;
  final double? maxHeight;
  final double? minHeight;

  const TitledScrollingCard({
    super.key,
    required this.title,
    required this.children,
    this.onClickSeeAll,
    required this.isEmpty,
    this.radius,
    required this.itemCount,
    this.maxHeight = 250, // Default max height when scrollable
    this.minHeight, // Optional minimum height
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
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title and "see all" button
          Padding(
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
                        style: tt.labelMedium!.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
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
                  child: Divider(color: cs.onSurface.withValues(alpha: 0.2)),
                ),
              ],
            ),
          ),

          // Content area
          if (isEmpty)
            SizedBox(
              height: minHeight ?? 150, // Use minHeight if provided
              child: const MyLoadingAnimation(
                title: "no data",
                height: 100,
                paddingValue: 0,
                showAnimation: false,
              ),
            )
          else if (itemCount < 3)
            // Content with intrinsic height when few items
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minHeight ?? 0, // Use minHeight if provided
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            )
          else
            // Scrollable content when many items
            SizedBox(
              height: maxHeight,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
