import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import '../components/my_search_field.dart';
import '../components/order_card_3.dart';

class DriverOrdersTab extends StatelessWidget {
  const DriverOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<DriverHomeController>(
      builder: (controller) {
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: AppBar(
                    backgroundColor: cs.surface,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent, // Add this line
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: cs.surface, // Match your AppBar
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: () {
                        controller.homeNavigationController.changeTab(1);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: cs.onSurface,
                      ),
                    ),
                    title: Text(
                      "orders".tr,
                      style: tt.titleMedium!.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     IconButton(
                //       onPressed: () {
                //         controller.homeNavigationController.changeTab(1);
                //       },
                //       icon: Icon(
                //         Icons.arrow_back,
                //         color: cs.onSurface,
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(top: 36, bottom: 20, left: 20, right: 20),
                //       child: Text(
                //         "orders".tr,
                //         style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                //   child: Material(
                //     elevation: 2,
                //     borderRadius: BorderRadius.all(Radius.circular(15)),
                //     child: TextField(
                //       decoration: InputDecoration(
                //         constraints: BoxConstraints(maxHeight: 50),
                //         prefixIcon: Padding(
                //           padding: const EdgeInsets.all(6.0),
                //           // child: CircleAvatar(
                //           //   backgroundColor: cs.onPrimary,
                //           //   foregroundColor: cs.primary,
                //           //   radius: 10,
                //           //   child: Icon(
                //           //     Icons.search,
                //           //     size: 20,
                //           //   ),
                //           // ),
                //           child: Icon(
                //             Icons.search,
                //             size: 30,
                //             color: cs.primary,
                //           ),
                //         ),
                //         floatingLabelBehavior: FloatingLabelBehavior.never,
                //         filled: true,
                //         //fillColor: Color.lerp(cs.primary.withOpacity(0.5), Colors.white, 0.5),
                //         fillColor: cs.secondaryContainer,
                //         enabledBorder: const OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(15)),
                //           borderSide: BorderSide(
                //             width: 0,
                //             color: Colors.transparent,
                //           ),
                //         ),
                //         focusedBorder: const OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(15)),
                //           borderSide: BorderSide(
                //             width: 0,
                //             color: Colors.transparent,
                //           ),
                //         ),
                //         label: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //           child: Text(
                //             "search".tr,
                //             style: tt.titleSmall!.copyWith(color: cs.onSecondaryContainer),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: MySearchField(
                    label: "search".tr,
                    textEditingController: controller.searchQueryMyOrders,
                    icon: Icon(Icons.search, color: cs.primary),
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
                          controller.orderTypes.length + 1,
                          (i) => GestureDetector(
                            onTap: () {
                              i == controller.orderTypes.length
                                  ? controller.setOrderType("type", false, selectAll: true)
                                  : controller.setOrderType(controller.orderTypes[i], false);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                              decoration: BoxDecoration(
                                color: i == controller.orderTypes.length
                                    ? controller.selectedOrderTypes.length == controller.orderTypes.length
                                        ? cs.primary
                                        : Colors.transparent
                                    : controller.selectedOrderTypes.contains(controller.orderTypes[i])
                                        ? cs.primary
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: cs.onSurface.withOpacity(0.2),
                                  width: 0.5,
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black.withOpacity(0.5),
                                //     spreadRadius: 0.5,
                                //     blurRadius: 4,
                                //     offset: const Offset(-1, 2),
                                //   ),
                                // ],
                              ),
                              child: Row(
                                children: [
                                  if (i != controller.orderTypes.length)
                                    Icon(
                                      controller.orderIcons[i],
                                      color: controller.selectedOrderTypes.contains(controller.orderTypes[i])
                                          ? cs.onPrimary
                                          : cs.primary,
                                      size: 16,
                                    ),
                                  SizedBox(width: 8),
                                  Text(
                                    i == controller.orderTypes.length ? "all".tr : controller.orderTypes[i].tr,
                                    style: tt.labelSmall!.copyWith(
                                      color: i == controller.orderTypes.length
                                          ? controller.selectedOrderTypes.length == controller.orderTypes.length
                                              ? cs.onPrimary
                                              : cs.primary
                                          : controller.selectedOrderTypes.contains(controller.orderTypes[i])
                                              ? cs.onPrimary
                                              : cs.primary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
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
                                    itemBuilder: (context, i) => OrderCard3(
                                      order: controller.myOrders[i],
                                      isCustomer: false,
                                      isLast: i == controller.myOrders.length - 1,
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
