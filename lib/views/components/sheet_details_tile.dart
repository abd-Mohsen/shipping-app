import 'package:flutter/material.dart';

class SheetDetailsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? color;

  const SheetDetailsTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.5)),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          Text(
            // "${Jiffy.parseFromDateTime(invoice.paymentDate).format(pattern: "d / M / y")}"
            // "  ${Jiffy.parseFromDateTime(invoice.paymentDate).jm}",
            subtitle,
            style: tt.labelMedium!.copyWith(color: color ?? cs.onSurface),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
