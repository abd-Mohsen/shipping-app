import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:popover/popover.dart';
import 'package:shipment/models/order_model.dart';
import 'package:get/get.dart';
import 'package:shipment/views/order_view.dart';

//todo: put read data (expired date) in order_view
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isCustomer;

  const OrderCard({
    super.key,
    required this.order,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Get.to(() => OrderView(order: order, isCustomer: isCustomer));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          //color: cs.secondaryContainer,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: order.status == "processing" ? cs.primary : cs.surface,
                width: order.status == "processing" ? 1.5 : 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
              color: cs.secondaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Icon(
                  Icons.local_shipping,
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
                        order.description,
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Text(
                        "${order.startPoint.name} - ${order.endPoint.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall!.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            " ${Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y")}"
                            "  ${Jiffy.parseFromDateTime(order.dateTime).jm}",
                            style: tt.titleSmall!.copyWith(
                              color:
                                  order.dateTime.isBefore(DateTime.now()) && !["draft", "done"].contains(order.status)
                                      ? cs.error
                                      : cs.onSurface.withOpacity(0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Visibility(
                          visible: order.dateTime.isBefore(DateTime.now()) && !["draft", "done"].contains(order.status),
                          child: GestureDetector(
                            onTap: () {
                              showPopover(
                                context: context,
                                backgroundColor: cs.surface,
                                bodyBuilder: (context) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  child: Text(
                                    "order was not accepted in time".tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.info, color: cs.error, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (order.status == "pending" && isCustomer)
                  Icon(
                    Icons.access_time_rounded,
                    color: cs.onSurface,
                    size: 25,
                  ),
                if (order.status == "approved" && !isCustomer)
                  Icon(
                    Icons.access_time_rounded,
                    color: cs.onSurface,
                    size: 25,
                  ),
                if (order.status == "done")
                  Icon(
                    Icons.task_alt,
                    color: cs.onSurface,
                    size: 25,
                  ),
                if (order.status == "processing" && !isCustomer)
                  Icon(
                    Icons.location_searching,
                    color: cs.primary,
                    size: 25,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
