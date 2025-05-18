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
        return Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  cs.primary.withOpacity(0.7),
                  BlendMode.srcATop, // Replaces all colors with solid red
                ),
                child: Image.asset(
                  "assets/images/background.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 36, bottom: 20, left: 20, right: 20),
                  child: Text(
                    "orders".tr,
                    style: tt.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      constraints: BoxConstraints(maxHeight: 50),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          backgroundColor: cs.onPrimary,
                          foregroundColor: cs.primary,
                          radius: 10,
                          child: Icon(
                            Icons.search,
                            size: 20,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Color.lerp(cs.primary.withOpacity(0.5), Colors.white, 0.5),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "search".tr,
                          style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 12),
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
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                              child: Text(
                                controller.orderTypes[i].tr,
                                style: tt.labelSmall!.copyWith(color: cs.onPrimary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                    child: Card(
                      color: cs.secondaryContainer,
                      elevation: 5,
                      child: controller.isLoading
                          ? SpinKitSquareCircle(color: cs.primary)
                          : RefreshIndicator(
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
                                  : ListView.builder(
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
