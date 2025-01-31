import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/order_controller.dart';
import 'package:shipment/models/order_model.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/edit_order_view.dart';

class OrderView extends StatelessWidget {
  //todo: make it different depending on status, and on wither if the user is driver or customer
  //todo: improve
  //todo: edit and delete
  //todo: add payment methods, driver details and status
  final OrderModel order;
  final bool isCustomer;
  const OrderView({
    super.key,
    required this.order,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    late CustomerHomeController cHC;
    if (isCustomer) cHC = Get.find();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'view order'.toUpperCase(),
          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          if (isCustomer)
            IconButton(
              onPressed: () {
                Get.to(() => EditOrderView(order: order));
              },
              icon: Icon(Icons.edit),
            ),
          if (isCustomer)
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "",
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "delete the order?".tr,
                      style: tt.titleLarge!.copyWith(color: cs.onSurface),
                    ),
                  ),
                  confirm: TextButton(
                    onPressed: () {
                      Get.back();
                      cHC.deleteOrder(order.id);
                    },
                    child: Text(
                      "yes",
                      style: tt.titleMedium!.copyWith(color: Colors.red),
                    ),
                  ),
                  cancel: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "no",
                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.delete),
            )
        ],
      ),
      body: GetBuilder<OrderController>(
        init: OrderController(),
        builder: (controller) {
          return Column(
            children: [
              if (isCustomer)
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.2,
                  child: OSMFlutter(
                    controller: controller.mapController,
                    mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                    osmOption: OSMOption(
                      isPicker: true,
                      userLocationMarker: UserLocationMaker(
                        personMarker: MarkerIcon(
                          icon: Icon(Icons.person, color: cs.primary, size: 40),
                        ),
                        directionArrowMarker: MarkerIcon(
                          icon: Icon(Icons.location_history, color: cs.primary, size: 40),
                        ),
                      ),
                      zoomOption: const ZoomOption(
                        initZoom: 16,
                      ),
                    ),
                  ),
                ),
              if (!isCustomer)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    onTap: () {
                      //
                    },
                    child: Center(
                      child: false
                          ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                          : Text(
                              "apply".tr.toUpperCase(),
                              style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                            ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        order.price + " " + "SYP",
                        style: tt.headlineMedium!.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        order.description,
                        style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: cs.onSurface,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            order.orderLocation.name,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: cs.onSurface,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y"),
                            style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: cs.onSurface,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            Jiffy.parseFromDateTime(order.dateTime).jm,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    if (!isCustomer)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: cs.onSurface,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              order.orderOwner.name,
                              style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(
                        thickness: 2,
                        color: cs.primary,
                        indent: 80,
                        endIndent: 80,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "address".tr,
                      style: tt.titleLarge!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              "from",
                              style: tt.titleMedium!
                                  .copyWith(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Text(
                              order.startPoint.toString(),
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              "to",
                              style: tt.titleMedium!
                                  .copyWith(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Text(
                              order.endPoint.toString(),
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (isCustomer)
                    //   ListTile(
                    //     //leading: Icon(Icons.date_range),
                    //     title: Text(
                    //       "date",
                    //       style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                    //       overflow: TextOverflow.ellipsis,
                    //       maxLines: 1,
                    //     ),
                    //     subtitle: Text(
                    //       " ${Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y")}"
                    //       "  ${Jiffy.parseFromDateTime(order.dateTime).jm}",
                    //       style: tt.titleSmall!.copyWith(color: cs.onSurface),
                    //       overflow: TextOverflow.ellipsis,
                    //       maxLines: 3,
                    //     ),
                    //   ),
                    // if (isCustomer)
                    //   ListTile(
                    //     leading: Icon(
                    //       Icons.monetization_on,
                    //     ),
                    //     title: Text(
                    //       "expected price",
                    //       style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                    //       overflow: TextOverflow.ellipsis,
                    //       maxLines: 1,
                    //     ),
                    //     subtitle: Text(
                    //       order.price,
                    //       style: tt.titleSmall!.copyWith(color: cs.onSurface),
                    //       overflow: TextOverflow.ellipsis,
                    //       maxLines: 1,
                    //     ),
                    //   ),//
                    // if (isCustomer)
                    //   ListTile(
                    //     leading: Icon(
                    //       Icons.task_alt,
                    //       color: Colors.yellowAccent,
                    //     ),
                    //     title: Text(
                    //       "status",
                    //       style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                    //       overflow: TextOverflow.ellipsis,
                    //       maxLines: 1,
                    //     ),
                    //     subtitle: Text(
                    //       order.status,
                    //       style: tt.titleSmall!.copyWith(color: cs.onSurface),
                    //       overflow: TextOverflow.ellipsis,
                    //       maxLines: 1,
                    //     ),
                    //   ),
                    const SizedBox(height: 24),
                    Text(
                      "details".tr,
                      style: tt.titleLarge!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    if (order.otherInfo != null)
                      ListTile(
                        title: Text(
                          order.otherInfo!,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            "${"weight".tr}: ",
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Text(
                              order.weight,
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (order.withCover)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.8,
                              child: Text(
                                "covered vehicle is required",
                                style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            "${"added at".tr}: ",
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: Text(
                              Jiffy.parseFromDateTime(order.createdAt).format(pattern: "d / M / y"),
                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
