import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/models/mini_order_model.dart';

class MiniOrderCard extends StatelessWidget {
  final MiniOrderModel order;
  //todo show other details like description and employee

  const MiniOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: order.orderStatus == "processing" ? cs.primary : cs.onSurface,
          width: order.orderStatus == "processing" ? 1.5 : 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  order.orderId.toString(),
                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  order.orderLocation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tt.labelMedium!.copyWith(
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Text(
                  " ${Jiffy.parseFromDateTime(order.orderDateTime).format(pattern: "d / M / y")}"
                  "  ${Jiffy.parseFromDateTime(order.orderDateTime).jm}",
                  style: tt.labelLarge!.copyWith(color: cs.onSurface.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          if (order.orderStatus == "pending")
            Icon(
              Icons.access_time_rounded,
              color: cs.onSurface,
              size: 20,
            ),
          if (order.orderStatus == "approved")
            Icon(
              Icons.access_time_rounded,
              color: cs.onSurface,
              size: 20,
            ),
          if (order.orderStatus == "done")
            Icon(
              Icons.task_alt,
              color: cs.onSurface,
              size: 20,
            ),
        ],
      ),
    );
  }
}
