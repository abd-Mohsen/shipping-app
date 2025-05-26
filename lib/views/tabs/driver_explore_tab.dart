import 'dart:ui';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/models/governorate_model.dart';
import '../../controllers/driver_home_controller.dart';
import '../components/my_search_field.dart';
import '../components/order_card.dart';
import '../components/order_card_3.dart';

class DriverExploreTab extends StatelessWidget {
  const DriverExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<DriverHomeController>(builder: (controller) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                "new order".tr,
                style: tt.titleMedium!.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: controller.isLoadingGovernorates
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 32, bottom: 12, left: 8, right: 8),
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.circle, size: 10, color: cs.onSurface),
                          //       const SizedBox(width: 8),
                          //       Text(
                          //         "show orders in governorate:".tr,
                          //         style: tt.titleSmall!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                          //         textAlign: TextAlign.start,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                                  child: MySearchField(
                                    label: "search".tr,
                                    textEditingController: controller.searchQuery2,
                                    icon: Padding(
                                      padding: const EdgeInsets.only(right: 20.0, left: 12),
                                      child: Icon(Icons.search, color: cs.primary),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //todo: implement filters
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    enableDrag: true,
                                    builder: (context) => BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                        height: MediaQuery.of(context).size.height / 2.2,
                                        decoration: BoxDecoration(
                                          color: cs.surface,
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            //
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                                padding: const EdgeInsets.symmetric(vertical: 16),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: cs.primary,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "ok".tr,
                                                    style: tt.labelMedium!.copyWith(color: cs.onPrimary),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: cs.primary,
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.sliders,
                                    color: cs.onPrimary,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Material(
                              elevation: 1.5,
                              borderRadius: BorderRadius.circular(15),
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
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        width: .5,
                                        color: cs.surface,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Divider(
                              color: cs.onSurface.withOpacity(0.2),
                              thickness: 1.5,
                              indent: screenWidth / 4,
                              endIndent: screenWidth / 4,
                            ),
                          )
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
                                      style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
