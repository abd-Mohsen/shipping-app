import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/company_home_controller.dart';

import '../../models/governorate_model.dart';
import '../components/order_card.dart';

class CompanyOrdersTab extends StatelessWidget {
  const CompanyOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CompanyHomeController>(
      builder: (controller) {
        return TabBarView(
          children: [
            //history
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
              child: controller.isLoadingHistory
                  ? SpinKitSquareCircle(color: cs.primary)
                  : RefreshIndicator(
                      onRefresh: controller.refreshHistoryOrders,
                      child: controller.historyOrders.isEmpty
                          ? Center(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Lottie.asset("assets/animations/timer.json", height: 200),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                    child: Center(
                                      child: Text(
                                        "no data, pull down to refresh".tr,
                                        style:
                                            tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.historyOrders.length,
                              itemBuilder: (context, i) =>
                                  OrderCard(order: controller.historyOrders[i], isCustomer: false),
                            ),
                    ),
            ),
            //curr
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                        style:
                                            tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
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
                                  return Padding(
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
                                  );
                                }
                                return OrderCard(order: controller.currOrders[i - 2], isCustomer: false);
                              }),
                    ),
            ),
            //explore
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: controller.isLoadingGovernorates
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: SpinKitThreeBounce(color: cs.primary, size: 20),
                        )
                      : controller.selectedGovernorate == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.getGovernorates();
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                                ),
                                child: Text(
                                  'خطأ, انقر للتحديث',
                                  style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20, bottom: 12, left: 8, right: 8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.circle, size: 10, color: cs.onSurface),
                                      const SizedBox(width: 8),
                                      Text(
                                        "show orders in governorate:".tr,
                                        style:
                                            tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(10),
                                  child: DropdownSearch<GovernorateModel>(
                                    validator: (type) {
                                      if (type == null) return "you must select a governorate".tr;
                                      return null;
                                    },
                                    selectedItem: controller.selectedGovernorate,
                                    compareFn: (type1, type2) => type1.id == type2.id,
                                    popupProps: PopupProps.menu(
                                      showSearchBox: false,
                                      menuProps: MenuProps(
                                        elevation: 5,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(10), // Only round bottom corners
                                            top: Radius.circular(10), // Only round bottom corners
                                          ),
                                        ),
                                        backgroundColor: cs.surface,
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      searchFieldProps: TextFieldProps(
                                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white70,
                                          hintText: "governorate name".tr,
                                          prefix: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(Icons.search, color: cs.onSurface),
                                          ),
                                        ),
                                      ),
                                    ),
                                    decoratorProps: DropDownDecoratorProps(
                                      baseStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: cs.secondaryContainer,
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                                          child: Icon(Icons.location_city, color: cs.primary),
                                        ),
                                        labelText: "selected governorate".tr,
                                        labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                                        floatingLabelBehavior: FloatingLabelBehavior.never,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            width: .5,
                                            color: cs.surface,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            width: 0.5,
                                            color: cs.onSurface,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            width: 0.5,
                                            color: cs.error,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32),
                                          borderSide: BorderSide(
                                            width: 1,
                                            color: cs.error,
                                          ),
                                        ),
                                      ),
                                    ),
                                    items: (filter, infiniteScrollProps) => controller.governorates,
                                    itemAsString: (GovernorateModel governorate) => governorate.name,
                                    onChanged: (GovernorateModel? governorate) async {
                                      controller.setGovernorate(governorate);
                                      // await Future.delayed(const Duration(milliseconds: 1000));
                                      // if (controller.buttonPressed) controller.formKey.currentState!.validate();
                                    },
                                    //enabled: !con.enabled,
                                  ),
                                ),
                              ],
                            ),
                ),
                //
                Expanded(
                  child: controller.isLoadingExplore
                      ? SpinKitSquareCircle(color: cs.primary)
                      : RefreshIndicator(
                          onRefresh: controller.refreshExploreOrders,
                          child: controller.exploreOrders.isEmpty
                              ? Center(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Lottie.asset("assets/animations/search.json", height: 300),
                                      Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Center(
                                          child: Text(
                                            "no data, pull down to refresh".tr,
                                            style: tt.titleMedium!
                                                .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  itemCount: controller.exploreOrders.length,
                                  itemBuilder: (context, i) => OrderCard(
                                    order: controller.exploreOrders[i],
                                    isCustomer: false,
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
