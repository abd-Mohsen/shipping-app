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

    //todo: show processing orders first (label them)
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
                          itemCount: controller.currOrders.length,
                          itemBuilder: (context, i) {
                            if (i == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Center(child: Lottie.asset("assets/animations/driver2.json", height: 200)),
                              );
                            }
                            return OrderCard(order: controller.currOrders[i - 1], isCustomer: false);
                          }),
                ),
        );
      },
    );
  }
}
