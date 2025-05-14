import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import '../components/order_card_2.dart';

class CustomerOrdersTab extends StatelessWidget {
  const CustomerOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CustomerHomeController>(
      builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 8),
              child: Text(
                "orders".tr,
                style: tt.titleMedium!.copyWith(color: cs.onSurface),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 4),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 14,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      controller.orderTypes.length,
                      (i) => GestureDetector(
                        onTap: () {
                          controller.setOrderType(controller.orderTypes[i], false);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                          decoration: BoxDecoration(
                            color: controller.selectedOrderTypes.contains(controller.orderTypes[i])
                                ? cs.primary
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 0.5,
                                blurRadius: 4,
                                offset: const Offset(-1, 2),
                              ),
                            ],
                          ),
                          child: Text(controller.orderTypes[i].tr),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: controller.isLoading
                  ? SpinKitSquareCircle(color: cs.primary)
                  : Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                      child: RefreshIndicator(
                        onRefresh: controller.refreshOrders,
                        child: controller.myOrders.isEmpty
                            ? Center(
                                child: ListView(
                                  shrinkWrap: true,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset("assets/animations/simple truck.json", height: 200),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Center(
                                        child: Text(
                                          "no data, pull down to refresh".tr,
                                          style: tt.titleMedium!.copyWith(
                                            color: cs.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 72),
                                  ],
                                ),
                              )
                            : Card(
                                elevation: 5,
                                color: cs.secondaryContainer,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  itemCount: controller.myOrders.length,
                                  itemBuilder: (context, i) => OrderCard2(
                                    order: controller.myOrders[i],
                                    isCustomer: true,
                                    isLast: i == controller.myOrders.length - 1,
                                  ),
                                ),
                              ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

// Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   child: CustomDropdown(
//     title: "order type".tr,
//     items: controller.orderTypes,
//     onSelect: (String? type) {
//       controller.setOrderType(type);
//     },
//     selectedValue: controller.selectedOrderType,
//     icon: Icons.filter_list,
//   ),
// ),
