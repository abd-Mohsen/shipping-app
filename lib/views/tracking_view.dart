import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent, // Add this line
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: cs.surface, // Match your AppBar
        // ),
        centerTitle: true,
        title: Text(
          "live tracking".tr,
          style: tt.titleMedium!.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetBuilder<OrderController>(builder: (controller) {
        return Stack(
          children: [
            map,
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
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
                        "description".tr,
                        style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.6)),
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
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          child: Text(
                            controller.order!.status.tr,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "weight".tr,
                                  style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.6)),
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
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "from".tr,
                                    style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.6)),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "to".tr,
                                    style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.6)),
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
                    ApplicationCard(
                      application: controller.order?.acceptedApplication ?? controller.order!.driversApplications.first,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
