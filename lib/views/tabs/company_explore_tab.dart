// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shipment/controllers/company_home_controller.dart';
// import 'package:shipment/views/components/filter_sheet.dart';
// import 'package:shipment/views/components/governorate_selector.dart';
// import '../../controllers/filter_controller.dart';
// import '../components/filter_button.dart';
// import '../components/my_search_field.dart';
// import '../components/order_card.dart';
//
// class CompanyExploreTab extends StatelessWidget {
//   const CompanyExploreTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     CompanyHomeController hC = Get.find();
//     ColorScheme cs = Theme.of(context).colorScheme;
//     TextTheme tt = Theme.of(context).textTheme;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return GetBuilder<CompanyHomeController>(
//       builder: (controller) {
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: AppBar(
//                 backgroundColor: cs.surface,
//                 elevation: 0,
//                 surfaceTintColor: Colors.transparent, // Add this line
//                 systemOverlayStyle: SystemUiOverlayStyle(
//                   statusBarColor: cs.surface, // Match your AppBar
//                 ),
//                 centerTitle: true,
//                 leading: IconButton(
//                   onPressed: () {
//                     controller.homeNavigationController.changeTab(1);
//                   },
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: cs.onSurface,
//                   ),
//                 ),
//                 title: Text(
//                   "new order".tr,
//                   style: tt.titleMedium!.copyWith(
//                     color: cs.onSurface,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: controller.isLoadingGovernorates
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16.0),
//                       child: SpinKitThreeBounce(color: cs.primary, size: 20),
//                     )
//                   : controller.selectedGovernorate == null
//                       ? Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               controller.getGovernorates();
//                             },
//                             style: ButtonStyle(
//                               backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
//                             ),
//                             child: Text(
//                               'خطأ, انقر للتحديث',
//                               style: tt.titleMedium!.copyWith(color: cs.onPrimary),
//                             ),
//                           ),
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
//                                     child: MySearchField(
//                                       label: "search".tr,
//                                       textEditingController: controller.searchQueryExploreOrders,
//                                       icon: Padding(
//                                         padding: const EdgeInsets.only(right: 20.0, left: 12),
//                                         child: Icon(Icons.search, color: cs.primary),
//                                       ),
//                                       onChanged: (s) {
//                                         controller.search(explore: true);
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 GetBuilder<FilterController>(builder: (controller) {
//                                   return FilterButton(
//                                     showBadge: controller.isFilterApplied,
//                                     sheet: FilterSheet(
//                                       showGovernorate: false,
//                                       showPrice: false,
//                                       showVehicleType: true,
//                                       onConfirm: () {
//                                         Get.back();
//                                         hC.refreshExploreOrders();
//                                       },
//                                     ),
//                                   );
//                                 }),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 4),
//                               child: GovernorateSelector(
//                                 selectedItem: controller.selectedGovernorate,
//                                 items: controller.governorates,
//                                 onChanged: (g) {
//                                   controller.setGovernorate(g);
//                                 },
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 16.0),
//                               child: Divider(
//                                 color: cs.onSurface.withOpacity(0.2),
//                                 thickness: 1.5,
//                                 indent: screenWidth / 4,
//                                 endIndent: screenWidth / 4,
//                               ),
//                             )
//                           ],
//                         ),
//             ),
//             //
//             Expanded(
//               child: controller.isLoadingExplore
//                   ? SpinKitSquareCircle(color: cs.primary)
//                   : RefreshIndicator(
//                       onRefresh: controller.refreshExploreOrders,
//                       child: controller.exploreOrders.isEmpty
//                           ? Center(
//                               child: ListView(
//                                 shrinkWrap: true,
//                                 children: [
//                                   Lottie.asset("assets/animations/search.json", height: 300),
//                                   Padding(
//                                     padding: const EdgeInsets.all(24),
//                                     child: Center(
//                                       child: Text(
//                                         "no data, pull down to refresh".tr,
//                                         style:
//                                             tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : ListView.builder(
//                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                               itemCount: controller.exploreOrders.length,
//                               itemBuilder: (context, i) => OrderCard(
//                                 order: controller.exploreOrders[i],
//                                 isCustomer: false,
//                               ),
//                             ),
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
