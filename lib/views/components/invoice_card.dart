import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/invoice_model.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceCard({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        color: cs.secondaryContainer,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: cs.surface,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Icon(
                Icons.attach_money,
                color: cs.primary,
                size: 35,
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      invoice.amount + " syp",
                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Text(
                      invoice.branch.address.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleSmall!.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Text(
                      "#${invoice.id.toString()}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleSmall!.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Text(
                      " ${Jiffy.parseFromDateTime(invoice.paymentDate).format(pattern: "d / M / y")}"
                      "  ${Jiffy.parseFromDateTime(invoice.paymentDate).jm}",
                      style: tt.titleSmall!.copyWith(
                        color: cs.onSurface.withOpacity(0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
