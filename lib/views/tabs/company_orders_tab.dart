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

    return GetBuilder<CompanyHomeController>(builder: (controller) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: controller.isLoadingGovernorates
                ? SpinKitThreeBounce(color: cs.primary, size: 20)
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
                    : DropdownSearch<GovernorateModel>(
                        //todo: show refresh button if failed
                        validator: (type) {
                          if (type == null) return "you must select a governorate".tr;
                          return null;
                        },
                        selectedItem: controller.selectedGovernorate,
                        compareFn: (type1, type2) => type1.id == type2.id,
                        popupProps: PopupProps.menu(
                          showSearchBox: false,
                          menuProps: MenuProps(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Icon(Icons.location_city),
                            ),
                            labelText: "selected governorate".tr,
                            labelStyle: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                width: .5,
                                color: cs.onSurface,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                width: 0.5,
                                color: cs.onSurface,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
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
                                      style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
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
      );
    });
  }
}
