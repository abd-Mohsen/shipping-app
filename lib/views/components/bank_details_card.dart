import 'package:flutter/material.dart';
import 'package:shipment/models/bank_details_model.dart';

class BankDetailsCard extends StatelessWidget {
  final BankDetailsModel bankDetails;

  const BankDetailsCard({
    super.key,
    required this.bankDetails,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: cs.surface,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
            color: cs.secondaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 8),
              Icon(
                Icons.account_balance,
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
                      bankDetails.fullName,
                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Text(
                      bankDetails.accountDetails,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleSmall!.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
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
