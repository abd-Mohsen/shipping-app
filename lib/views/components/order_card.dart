import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/order_model.dart';
import 'package:get/get.dart';
import 'package:shipment/views/order_view.dart';

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
          borderRadius: BorderRadius.circular(20),
          elevation: 3,
          color: cs.surface,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: order.status == "processing" ? cs.primary : cs.onSurface,
                width: order.status == "processing" ? 1.5 : 0.5,
              ),
              borderRadius: BorderRadius.circular(20),
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
                    SizedBox(height: 12),
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
                    SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Text(
                        " ${Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y")}"
                        "  ${Jiffy.parseFromDateTime(order.dateTime).jm}",
                        style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.8)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
