import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:get/get.dart';
import 'package:shipment/views/order_view.dart';

import '../../models/order_model_2.dart';

class CurrOrderCard extends StatelessWidget {
  final OrderModel2? order;
  final BorderRadius borderRadius;
  const CurrOrderCard({super.key, this.order, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<IconData> stepperIcons = [
      Icons.done,
      Icons.watch_later,
      FontAwesomeIcons.truck,
      FontAwesomeIcons.box,
    ];

    List<String> orderTypes = ["not taken", "taken", "current", "finished"];

    int statusIndex = order == null ? -1 : 2;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
        child: GestureDetector(
          onTap: () {
            if (order == null) return;
            Get.to(() => OrderView(orderID: order!.id, openTracking: true));
          },
          child: Container(
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2), // Shadow color
                  blurRadius: 2, // Soften the shadow
                  spreadRadius: 1, // Extend the shadow
                  offset: const Offset(1, 1), // Shadow direction (x, y)
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "current shipping".tr,
                        style: tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(color: cs.onSurface.withValues(alpha: 0.2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                order == null ? "N/A".tr : "#${order!.id} - ${order!.description}",
                                style: tt.labelMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (order != null)
                        Container(
                          decoration: BoxDecoration(
                            color: order!.status == "canceled"
                                ? Color.lerp(cs.primary, Colors.white, 0.22)
                                : order!.status == "done"
                                    ? Color.lerp(Colors.green, Colors.white, 0.15)
                                    : order!.status == "processing"
                                        ? cs.primaryContainer
                                        : cs.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            child: Text(
                              order!.status.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tt.labelSmall!.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 80,
                    //width: double.infinity,
                    child: EasyStepper(
                      activeStep: statusIndex,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      activeStepTextColor: cs.primary,
                      finishedStepTextColor: cs.onSurface,
                      unreachedStepTextColor: cs.onSurface.withValues(alpha: 0.6),
                      finishedStepBackgroundColor: cs.secondaryContainer,
                      internalPadding: 0, // Removes padding around the whole stepper
                      showLoadingAnimation: false,
                      stepRadius: 20, // Should match your CircleAvatar radius
                      showStepBorder: false,
                      lineStyle: LineStyle(
                        defaultLineColor: order == null ? Colors.grey : cs.primary,
                        lineType: LineType.dashed,
                        activeLineColor: Colors.grey,
                      ),
                      steps: List.generate(
                        4,
                        (i) => EasyStep(
                          customStep: CircleAvatar(
                            radius: statusIndex == i ? 20 : 14,
                            backgroundColor: statusIndex == i ? cs.primaryContainer : cs.primary,
                            child: FaIcon(
                              stepperIcons[i],
                              size: statusIndex == i ? 18 : 13,
                              color: Colors.white,
                            ),
                          ),
                          customTitle: Text(
                            orderTypes[i].tr,
                            style: tt.labelSmall!.copyWith(color: cs.onSurface, fontSize: 9.5),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (order != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order == null
                                    ? "- / - / -"
                                    : Jiffy.parseFromDateTime(order!.createdAt).format(
                                        pattern: "d / M / y",
                                      ),
                                style: tt.labelSmall!.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order?.startPoint.toString() ?? "-",
                                style: tt.labelSmall!.copyWith(color: cs.onSurface, fontSize: 10.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                order == null
                                    ? "- / - / -"
                                    : Jiffy.parseFromDateTime(order!.createdAt).format(
                                        pattern: "d / M / y",
                                      ),
                                style: tt.labelSmall!.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order?.endPoint.toString() ?? "-",
                                style: tt.labelSmall!.copyWith(color: cs.onSurface, fontSize: 10.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
