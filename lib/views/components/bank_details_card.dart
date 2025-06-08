import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/models/bank_details_model.dart';
import 'package:shipment/models/transfer_details_model.dart';

class PaymentDetailsCard extends StatelessWidget {
  final BankDetailsModel? bankDetails;
  final TransferDetailsModel? transferDetails;
  final bool isLast;

  const PaymentDetailsCard({
    super.key,
    this.bankDetails,
    this.transferDetails,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: order.status == "processing" ? cs.primary : cs.surface,
              //   width: order.status == "processing" ? 1.5 : 0.5,
              // ),
              // borderRadius: BorderRadius.circular(10),
              color: cs.surface,
            ),
            // padding: const EdgeInsets.all(12),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   color: cs.secondaryContainer,
            //   border: Border.all(
            //     color: cs.surface,
            //     width: 0.5,
            //   ),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.2), // Shadow color
            //       blurRadius: 4, // Soften the shadow
            //       spreadRadius: 1, // Extend the shadow
            //       offset: const Offset(2, 2), // Shadow direction (x, y)
            //     ),
            //   ],
            // ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "full name".tr,
                      style: tt.labelMedium!.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transferDetails == null ? "account details".tr : "phone".tr,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelMedium!.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transferDetails == null ? bankDetails!.fullName : transferDetails!.fullName,
                        style: tt.labelMedium!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transferDetails == null ? bankDetails!.accountDetails : transferDetails!.phone,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: tt.labelMedium!.copyWith(color: cs.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: cs.onSurface.withOpacity(0.2),
                // indent: MediaQuery.of(context).size.width / 15,
                // endIndent: MediaQuery.of(context).size.width / 15,
              ),
            ),
        ],
      ),
    );
  }
}
