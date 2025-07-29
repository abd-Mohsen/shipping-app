import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/views/order_view.dart';

import '../../models/order_model_2.dart';

class OrderCard3 extends StatelessWidget {
  final OrderModel2 order;
  final bool isCustomer;
  final bool? isLast;

  const OrderCard3({
    super.key,
    required this.order,
    required this.isCustomer,
    this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Get.to(() => OrderView(orderID: order.id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2), // Shadow color
                blurRadius: 2, // Soften the shadow
                spreadRadius: 1, // Extend the shadow
                offset: const Offset(1, 1), // Shadow direction (x, y)
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: cs.surface,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
              color: cs.secondaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 37,
                        height: 37,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xffD8D8D9), Color(0xffC8C8C8)],
                            stops: [0, 1],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: order.status == "done"
                              ? FaIcon(
                                  FontAwesomeIcons.box,
                                  color: cs.onPrimary,
                                  size: 18,
                                )
                              : order.status == "canceled"
                                  ? FaIcon(
                                      Icons.close,
                                      color: cs.onPrimary,
                                      size: 18,
                                    )
                                  : order.status == "processing"
                                      ? FaIcon(
                                          Icons.local_shipping,
                                          color: cs.onPrimary,
                                          size: 20,
                                        )
                                      : FaIcon(
                                          FontAwesomeIcons.clock,
                                          color: cs.onPrimary,
                                          size: 18,
                                        ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.description,
                              style: tt.labelMedium!.copyWith(color: cs.onSurface),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.shortAddress(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: tt.labelSmall!.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.5),
                                fontSize: 10,
                              ),
                            ),
                            // const SizedBox(height: 8),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: MediaQuery.of(context).size.width / 2.5,
                            //       child: Text(
                            //         " ${Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y")}"
                            //         "  ${Jiffy.parseFromDateTime(order.dateTime).jm}",
                            //         style: tt.titleSmall!.copyWith(
                            //           color:
                            //               order.dateTime.isBefore(DateTime.now()) && !["draft", "done"].contains(order.status)
                            //                   ? cs.error
                            //                   : cs.onSurface.withOpacity(0.8),
                            //         ),
                            //         overflow: TextOverflow.ellipsis,
                            //         maxLines: 1,
                            //       ),
                            //     ),
                            //     const SizedBox(width: 4),
                            //     Visibility(
                            //       visible: order.dateTime.isBefore(DateTime.now()) && !["draft", "done"].contains(order.status),
                            //       child: GestureDetector(
                            //         onTap: () {
                            //           showPopover(
                            //             context: context,
                            //             backgroundColor: cs.surface,
                            //             bodyBuilder: (context) => Padding(
                            //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            //               child: Text(
                            //                 "order was not accepted in time".tr,
                            //                 style: tt.titleMedium!.copyWith(color: cs.onSurface),
                            //                 overflow: TextOverflow.ellipsis,
                            //                 maxLines: 2,
                            //               ),
                            //             ),
                            //           );
                            //         },
                            //         child: Icon(Icons.info, color: cs.error, size: 20),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: order.status == "canceled"
                        ? Color.lerp(cs.primary, Colors.white, 0.22)
                        : order.status == "done"
                            ? Color.lerp(Colors.green, Colors.white, 0.15)
                            : order.status == "processing"
                                ? cs.primaryContainer
                                : cs.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Text(
                      order.status.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelSmall!.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
                //
                //
                // if (order.status == "pending" && isCustomer)
                //   Icon(
                //     Icons.access_time_rounded,
                //     color: cs.onSurface,
                //     size: 25,
                //   ),
                // if (order.status == "approved" && !isCustomer)
                //   Icon(
                //     Icons.access_time_rounded,
                //     color: cs.onSurface,
                //     size: 25,
                //   ),
                // if (order.status == "done")
                //   Icon(
                //     Icons.task_alt,
                //     color: cs.onSurface,
                //     size: 25,
                //   ),
                // if (order.status == "processing" && !isCustomer)
                //   Icon(
                //     Icons.location_searching,
                //     color: cs.primary,
                //     size: 25,
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
