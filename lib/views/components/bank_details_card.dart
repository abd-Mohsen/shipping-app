import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shipment/models/bank_details_model.dart';
import 'package:shipment/models/transfer_details_model.dart';

class PaymentDetailsCard extends StatelessWidget {
  final BankDetailsModel? bankDetails;
  final TransferDetailsModel? transferDetails;

  const PaymentDetailsCard({
    super.key,
    this.bankDetails,
    this.transferDetails,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cs.secondaryContainer,
          border: Border.all(
            color: cs.surface,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 4, // Soften the shadow
              spreadRadius: 1, // Extend the shadow
              offset: const Offset(2, 2), // Shadow direction (x, y)
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Center(
              child: Icon(
                bankDetails == null ? FontAwesomeIcons.idCard : Icons.account_balance,
                color: cs.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      transferDetails == null ? bankDetails!.fullName : transferDetails!.fullName,
                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    child: Text(
                      transferDetails == null ? bankDetails!.accountDetails : transferDetails!.fullName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelMedium!.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
