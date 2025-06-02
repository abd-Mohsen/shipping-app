import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BlurredSheet extends StatelessWidget {
  final Widget content;
  final String title;
  final String confirmText;
  final void Function() onConfirm;
  final double? height;
  final bool? isLoading;

  const BlurredSheet({
    super.key,
    required this.content,
    required this.title,
    required this.confirmText,
    required this.onConfirm,
    this.height,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        height: height ?? MediaQuery.of(context).size.height / 2.2,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
                  child: Text(
                    title,
                    style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: cs.onSurface.withOpacity(0.2),
                  indent: 20,
                  endIndent: 60,
                ),
              ],
            ),
            //
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: content,
                ),
              ),
            ),
            //
            GestureDetector(
              onTap: onConfirm,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isLoading ?? false
                    ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                    : Center(
                        child: Text(
                          confirmText,
                          style: tt.labelMedium!.copyWith(color: cs.onPrimary),
                          textAlign: TextAlign.start,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
