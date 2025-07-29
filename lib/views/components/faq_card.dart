import 'package:flutter/material.dart';
import 'package:shipment/models/faq_model.dart';

class FaqCard extends StatelessWidget {
  final FaqModel faq;

  const FaqCard({
    super.key,
    required this.faq,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cs.secondaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // Shadow color
              blurRadius: 4, // Soften the shadow
              spreadRadius: 1, // Extend the shadow
              offset: const Offset(2, 2), // Shadow direction (x, y)
            ),
          ],
        ),
        child: ExpansionTile(
          backgroundColor: cs.secondaryContainer,
          collapsedBackgroundColor: cs.secondaryContainer,
          leading: Icon(
            Icons.question_answer,
            color: cs.primary,
            size: 35,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              faq.question,
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
          ),
          // subtitle: Padding(
          //   padding: const EdgeInsets.only(bottom: 8.0),
          //   child: SizedBox(
          //     width: MediaQuery.of(context).size.width / 1.6,
          //     child: Text(
          //       faq.vehicleTypeInfo.type,
          //       maxLines: 2,
          //       overflow: TextOverflow.ellipsis,
          //       style: tt.titleSmall!.copyWith(
          //         color: cs.onSurface.withOpacity(0.5),
          //       ),
          //     ),
          //   ),
          // ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: cs.surface,
              width: 1,
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: cs.surface,
              width: 0.5,
            ),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Text(
                    faq.answer,
                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
