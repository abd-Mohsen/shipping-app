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

    return GetBuilder<DriverHomeController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Text(
                                    "no ongoing orders, pull down to refresh".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.currOrders.length,
                          itemBuilder: (context, i) => OrderCard(order: controller.currOrders[i], isCustomer: false),
                        ),
                ),
        );
      },
    );
  }
}
