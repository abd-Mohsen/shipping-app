import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:popover/popover.dart';
import 'package:shipment/models/order_model.dart';
import 'package:get/get.dart';
import 'package:shipment/views/order_view.dart';

//todo: put red data (expired date) in order_view
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
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.lerp(cs.primary, Colors.white, 0.1)!,
                          Color.lerp(cs.primary, Colors.white, 0.6)!
                        ],
                        stops: const [0, 1],
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
                                  FontAwesomeIcons.close,
                                  color: cs.onPrimary,
                                  size: 18,
                                )
                              : order.status == "processing"
                                  ? FaIcon(
                                      FontAwesomeIcons.truckMoving,
                                      color: cs.onPrimary,
                                      size: 18,
                                    )
                                  : FaIcon(
                                      FontAwesomeIcons.clock,
                                      color: cs.onPrimary,
                                      size: 18,
                                    ),
                    ),
                  ),
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      order.description,
                      style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: order.status == "canceled"
                          ? Color.lerp(cs.primary, Colors.white, 0.22)
                          : order.status == "done"
                              ? Color.lerp(Colors.green, Colors.white, 0.15)
                              : order.status == "processing"
                                  ? Color.lerp(Colors.blue, Colors.white, 0.3)
                                  : Color.lerp(Colors.black, Colors.white, 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //const SizedBox(height: 8),
                          Text(
                            "address".tr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.labelSmall!.copyWith(
                              color: cs.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "date".tr,
                            style: tt.labelSmall!.copyWith(
                              color: cs.onSurface.withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "expected price".tr,
                            style: tt.labelSmall!.copyWith(
                              color: cs.onSurface.withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //const SizedBox(height: 8),
                          Text(
                            "${order.startPoint.governorate} - ${order.endPoint.governorate}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.labelSmall!.copyWith(
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "${Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y")}"
                                "  ${Jiffy.parseFromDateTime(order.dateTime).jm}",
                                style: tt.labelSmall!.copyWith(
                                  color: order.dateTime.isBefore(DateTime.now()) &&
                                          !["draft", "done"].contains(order.status)
                                      ? cs.error
                                      : cs.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(width: 12),
                              Visibility(
                                visible: order.dateTime.isBefore(DateTime.now()) &&
                                    !["draft", "done"].contains(order.status),
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
                                  child: Icon(Icons.info, color: cs.error, size: 18),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${order.price}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.labelSmall!.copyWith(
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
