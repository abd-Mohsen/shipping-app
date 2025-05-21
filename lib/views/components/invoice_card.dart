import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/models/invoice_model.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final void Function()? onTap;

  const InvoiceCard({
    super.key,
    required this.invoice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 1,
          color: cs.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.moneyCheckDollar,
                    color: cs.onSurface,
                    size: 25,
                  ),
                ),
              ),
              title: Text(
                "#${invoice.id.toString()}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                invoice.branch?.name ?? "paid by bank transfer".tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.6)),
              ),
              trailing: Text(
                invoice.amount,
                style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              onTap: () {
                showMaterialModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.black.withOpacity(0.5),
                  enableDrag: true,
                  builder: (context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
                            child: Text(
                              "${"invoice".tr} #${invoice.id}",
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
                          Row(
                            children: [
                              Expanded(
                                child: InvoiceDetailsTile(
                                  title: "date".tr,
                                  subtitle: Jiffy.parseFromDateTime(invoice.paymentDate).format(pattern: "d / M / y"),
                                ),
                              ),
                              Expanded(
                                child: InvoiceDetailsTile(
                                  title: "time".tr,
                                  subtitle: Jiffy.parseFromDateTime(invoice.paymentDate).jm,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InvoiceDetailsTile(
                                  title: "paid amount".tr,
                                  subtitle: invoice.amount,
                                ),
                              ),
                              Expanded(
                                child: InvoiceDetailsTile(
                                  title: "branch name".tr,
                                  subtitle: invoice.branch?.name ?? "paid by bank transfer".tr,
                                ),
                              ),
                            ],
                          ),
                          if (invoice.branch != null)
                            InvoiceDetailsTile(
                              title: "branch address".tr,
                              subtitle: invoice.branch?.address.toString() ?? "",
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: cs.surface,
          //       width: 0.5,
          //     ),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       const SizedBox(width: 8),
          //       Container(
          //         height: 55,
          //         width: 55,
          //         decoration: BoxDecoration(
          //           color: cs.surface,
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: Center(
          //           child: FaIcon(
          //             FontAwesomeIcons.moneyCheckDollar,
          //             color: cs.onSurface,
          //             size: 25,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 24),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             width: MediaQuery.of(context).size.width / 2,
          //             child: Text(
          //               invoice.amount + " syp",
          //               style: tt.titleMedium!.copyWith(color: cs.onSurface),
          //               overflow: TextOverflow.ellipsis,
          //               maxLines: 2,
          //             ),
          //           ),
          //           const SizedBox(height: 12),
          //           SizedBox(
          //             width: MediaQuery.of(context).size.width / 1.6,
          //             child: Text(
          //               invoice.branch.address.toString(),
          //               maxLines: 3,
          //               overflow: TextOverflow.ellipsis,
          //               style: tt.titleSmall!.copyWith(
          //                 color: cs.onSurface.withOpacity(0.5),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 8),
          //           SizedBox(
          //             width: MediaQuery.of(context).size.width / 1.6,
          //             child: Text(
          //               "#${invoice.id.toString()}",
          //               maxLines: 3,
          //               overflow: TextOverflow.ellipsis,
          //               style: tt.titleSmall!.copyWith(
          //                 color: cs.onSurface.withOpacity(0.5),
          //               ),
          //             ),
          //           ),
          //           const SizedBox(height: 8),
          //           SizedBox(
          //             width: MediaQuery.of(context).size.width / 2.5,
          //             child: Text(
          //               " ${Jiffy.parseFromDateTime(invoice.paymentDate).format(pattern: "d / M / y")}"
          //               "  ${Jiffy.parseFromDateTime(invoice.paymentDate).jm}",
          //               style: tt.titleSmall!.copyWith(
          //                 color: cs.onSurface.withOpacity(0.8),
          //               ),
          //               overflow: TextOverflow.ellipsis,
          //               maxLines: 1,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          ),
    );
  }
}

class InvoiceDetailsTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const InvoiceDetailsTile({
    super.key,
    required this.title,
    required this.subtitle,
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
            style: tt.labelMedium!.copyWith(color: cs.onSurface),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
