import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/order_controller.dart';
import 'package:shipment/views/components/application_card.dart';

class TrackingView extends StatelessWidget {
  final Widget map;
  const TrackingView({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      body: GetBuilder<OrderController>(builder: (controller) {
        return Stack(
          children: [
            map,
            Positioned(
              top: 50,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2), // Shadow color
                      blurRadius: 3, // Soften the shadow
                      spreadRadius: 1.5, // Extend the shadow
                      offset: Offset(1, 1), // Shadow direction (x, y)
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: cs.primary,
                    size: 25,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.currPosition != null)
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2), // Shadow color
                            blurRadius: 3, // Soften the shadow
                            spreadRadius: 1.5, // Extend the shadow
                            offset: const Offset(1, 1), // Shadow direction (x, y)
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.mapController.moveTo(controller.currPosition!);
                        },
                        child: Icon(
                          Icons.my_location,
                          color: cs.primary,
                          size: 30,
                        ),
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                          blurRadius: 4, // Soften the shadow
                          spreadRadius: 2, // Extend the shadow
                          offset: Offset(1, 1), // Shadow direction (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "#${controller.order?.id ?? ""}".tr,
                            style: tt.labelMedium!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                          ),
                          subtitle: Text(
                            controller.order!.description,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: Color.lerp(Colors.blue, Colors.white, 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: Text(
                                controller.order!.status.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tt.labelSmall!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "weight".tr,
                                      style: tt.labelSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.order!.fullWeight(),
                                      style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "distance".tr,
                                      style: tt.labelSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${((controller.pathDistance ?? 0.0) / 1000).toStringAsFixed(2)} KM',
                                      style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: Color(0xFFFF0000)),
                                          Text(
                                            "from".tr,
                                            style: tt.labelSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.order!.startPoint.governorate,
                                        style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: Color(0xFF38B6FF)),
                                          Text(
                                            "to".tr,
                                            style: tt.labelSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        controller.order!.endPoint.governorate,
                                        style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          color: cs.onSurface.withValues(alpha: 0.2),
                          indent: 12,
                          endIndent: 20,
                        ),
                        if (controller.order?.acceptedApplication != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ApplicationCard(
                              application: controller.order!.acceptedApplication!,
                              isLast: true,
                              showPhone: false,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
