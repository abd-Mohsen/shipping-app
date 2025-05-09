import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/views/components/order_card.dart';
import '../../controllers/driver_home_controller.dart';

class DriverHomeTab extends StatelessWidget {
  const DriverHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    //todo: show something to tell if driver is sending location
    return GetBuilder<DriverHomeController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 0),
          child: controller.isLoadingCurrent
              ? SpinKitSquareCircle(color: cs.primary)
              : RefreshIndicator(
                  onRefresh: controller.refreshCurrOrders,
                  child: controller.currOrders.isEmpty
                      ? Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Lottie.asset("assets/animations/simple truck.json", height: 200),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Center(
                                  child: Text(
                                    "no data, pull down to refresh".tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.currOrders.length + 2,
                          itemBuilder: (context, i) {
                            if (i == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Center(child: Lottie.asset("assets/animations/driver2.json", height: 200)),
                              );
                            }
                            if (i == 1) {
                              return Column(
                                children: [
                                  if (controller.trackingID != 0)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Card(
                                        color: cs.secondaryContainer,
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     controller.refreshMap();
                                              //   },
                                              //   child: CircleAvatar(
                                              //     backgroundColor: cs.primary,
                                              //     foregroundColor: cs.onPrimary,
                                              //     child: Icon(Icons.refresh),
                                              //     radius: 20,
                                              //   ),
                                              // ),
                                              Icon(Icons.location_on,
                                                  color: controller.trackingStatus == "tracking"
                                                      ? Colors.green
                                                      : cs.primary),
                                              SizedBox(width: 12),
                                              Expanded(
                                                //width: MediaQuery.of(context).size.width / 1.2,
                                                child: Text(
                                                  controller.trackingStatus.tr,
                                                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.circle, size: 13, color: cs.onSurface),
                                        const SizedBox(width: 8),
                                        Text(
                                          "my current orders".tr,
                                          style: tt.titleMedium!
                                              .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return OrderCard(order: controller.currOrders[i - 2], isCustomer: false);
                          }),
                ),
        );
      },
    );
  }
}
