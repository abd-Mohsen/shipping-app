// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:multi_dropdown/multi_dropdown.dart';
// import 'package:shipment/controllers/customer_home_controller.dart';
//
// import '../models/address_model.dart';
// import '../models/location_model.dart';
// import '../models/order_model.dart';
// import '../models/payment_method_model.dart';
// import '../models/vehicle_type_model.dart';
// import '../services/remote_services.dart';
//
// class EditOrderController extends GetxController {
//   CustomerHomeController customerHomeController;
//   OrderModel order;
//
//   EditOrderController({required this.customerHomeController, required this.order});
//
//   @override
//   void onInit() async {
//     await getPaymentMethods();
//     await getVehicleTypes();
//     prePopulate();
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) {
//         mapController1.listenerMapSingleTapping.addListener(
//           () async {
//             if (startPosition != null) mapController1.removeMarker(startPosition!);
//             startPosition = mapController1.listenerMapSingleTapping.value!;
//             await mapController1.addMarker(
//               startPosition!,
//               markerIcon: const MarkerIcon(
//                 icon: Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                   size: 40,
//                 ),
//               ),
//             );
//           },
//         );
//         mapController2.listenerMapSingleTapping.addListener(
//           () async {
//             if (endPosition != null) mapController2.removeMarker(endPosition!);
//             endPosition = mapController2.listenerMapSingleTapping.value!;
//             await mapController2.addMarker(
//               endPosition!,
//               markerIcon: const MarkerIcon(
//                 icon: Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                   size: 40,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//     super.onInit();
//   }
//
//   MapController mapController1 = MapController(
//     initMapWithUserPosition: const UserTrackingOption(
//       enableTracking: true,
//       unFollowUser: true,
//     ),
//   );
//
//   MapController mapController2 = MapController(
//     initMapWithUserPosition: const UserTrackingOption(
//       enableTracking: true,
//       unFollowUser: true,
//     ),
//   );
//
//   GeoPoint? startPosition;
//   GeoPoint? endPosition;
//
//   LocationModel? sourceLocation;
//   LocationModel? targetLocation;
//
//   AddressModel? startAddress;
//   AddressModel? endAddress;
//
//   bool _isLoadingSelect1 = false;
//   bool get isLoadingSelect1 => _isLoadingSelect1;
//   void toggleLoadingSelect1(bool value) {
//     _isLoadingSelect1 = value;
//     update();
//   }
//
//   bool _isLoadingSelect2 = false;
//   bool get isLoadingSelect2 => _isLoadingSelect2;
//   void toggleLoadingSelect2(bool value) {
//     _isLoadingSelect2 = value;
//     update();
//   }
//
//   void calculateStartAddress() async {
//     toggleLoadingSelect1(true);
//     if (startPosition != null) {
//       sourceLocation = await RemoteServices.getAddressFromLatLng(startPosition!.latitude, startPosition!.longitude);
//       startAddress = sourceLocation?.addressEncoder();
//     }
//     toggleLoadingSelect1(false);
//   }
//
//   void calculateTargetAddress() async {
//     toggleLoadingSelect2(true);
//     if (endPosition != null) {
//       targetLocation = await RemoteServices.getAddressFromLatLng(endPosition!.latitude, endPosition!.longitude);
//       endAddress = targetLocation?.addressEncoder();
//     }
//     toggleLoadingSelect2(false);
//   }
//
//   void selectStartAddress(AddressModel address) {
//     Get.back();
//     Get.back();
//     // if (Get.routing.current != "/MakeOrderView") Get.back();
//     startAddress = address;
//     update();
//   }
//
//   void selectEndAddress(AddressModel address) {
//     Get.back();
//     Get.back();
//     // if (Get.routing.current != "/MakeOrderView") Get.back();
//     endAddress = address;
//     update();
//   }
//
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   bool buttonPressed = false;
//
//   TextEditingController description = TextEditingController();
//   TextEditingController price = TextEditingController();
//   TextEditingController weight = TextEditingController();
//   TextEditingController otherInfo = TextEditingController();
//   //TextEditingController accountName = TextEditingController();
//   MultiSelectController<PaymentMethodModel> paymentMethodController = MultiSelectController<PaymentMethodModel>();
//   MultiSelectController<VehicleTypeModel> vehicleTypeController = MultiSelectController<VehicleTypeModel>();
//
//   bool coveredCar = false;
//   void toggleCoveredCar() {
//     coveredCar = !coveredCar;
//     update();
//   }
//
//   DateTime? selectedDate;
//   void setDate(DateTime val) {
//     selectedDate = val;
//     update();
//   }
//
//   TimeOfDay? selectedTime;
//   void setTime(TimeOfDay val) {
//     selectedTime = val;
//     update();
//   }
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   void toggleLoading(bool value) {
//     _isLoading = value;
//     update();
//   }
//
//   List<PaymentMethodModel> paymentMethods = [];
//   List<VehicleTypeModel> vehicleTypes = [];
//
//   VehicleTypeModel? selectedVehicleType;
//   void selectVehicleType(VehicleTypeModel? vehicle) {
//     selectedVehicleType = vehicle;
//     update();
//   }
//
//   bool _isLoadingPayment = false;
//   bool get isLoadingPayment => _isLoadingPayment;
//   void toggleLoadingPayment(bool value) {
//     _isLoadingPayment = value;
//     update();
//   }
//
//   bool _isLoadingVehicle = false;
//   bool get isLoadingVehicle => _isLoadingVehicle;
//   void toggleLoadingVehicle(bool value) {
//     _isLoadingVehicle = value;
//     update();
//   }
//
//   Future<void> getPaymentMethods() async {
//     toggleLoadingPayment(true);
//     List<PaymentMethodModel> newPaymentMethods = await RemoteServices.fetchPaymentMethods() ?? [];
//     paymentMethods.addAll(newPaymentMethods);
//     toggleLoadingPayment(false);
//   }
//
//   Future<void> getVehicleTypes() async {
//     toggleLoadingVehicle(true);
//     List<VehicleTypeModel> newItems = await RemoteServices.fetchVehicleType() ?? [];
//     vehicleTypes.addAll(newItems);
//     toggleLoadingVehicle(false);
//   }
//
//   List formatPayment() {
//     List res = [];
//     for (final item in paymentMethodController.selectedItems) {
//       res.add({"payment": item.value.id});
//     }
//     return res;
//   }
//
//   void prePopulate() {
//     startAddress = order.startPoint;
//     endAddress = order.endPoint;
//     description.text = order.description;
//     price.text = order.price.toString();
//     weight.text = order.weight;
//     otherInfo.text = order.otherInfo ?? "";
//     selectedVehicleType = order.typeVehicle;
//     List currentPaymentMethodsIDs = order.paymentMethods.map((p) => p.payment.methodName).toList();
//     paymentMethodController.selectWhere((item) => currentPaymentMethodsIDs.contains(item.value.name));
//     DateTime orderDate = order.dateTime;
//     selectedDate = orderDate;
//     selectedTime = TimeOfDay(hour: orderDate.hour, minute: orderDate.minute);
//     //coveredCar = order.withCover;
//     update();
//   }
//
//   void editOrder() async {
//     if (isLoading || isLoadingVehicle || isLoadingPayment) return;
//     buttonPressed = true;
//     bool valid = formKey.currentState!.validate();
//     if (!valid) return;
//     if (startAddress == null || endAddress == null) {
//       Get.showSnackbar(GetSnackBar(
//         message: "pick positions first".tr,
//         duration: const Duration(milliseconds: 2500),
//       ));
//       return;
//     }
//     List<String> syriaNames = ["sy", "syria", "سوريا"];
//     if ((sourceLocation != null && !syriaNames.contains(sourceLocation!.country)) ||
//         (targetLocation != null && !syriaNames.contains(targetLocation!.country))) {
//       Get.showSnackbar(GetSnackBar(
//         message: "pick a position in syria".tr,
//         duration: const Duration(milliseconds: 2500),
//       ));
//       return;
//     }
//     if (selectedDate == null || selectedTime == null) {
//       Get.showSnackbar(GetSnackBar(
//         message: "pick a date and time first".tr,
//         duration: const Duration(milliseconds: 2500),
//       ));
//     }
//     DateTime desiredDate = DateTime(
//       selectedDate!.year,
//       selectedDate!.month,
//       selectedDate!.day,
//       selectedTime!.hour,
//       selectedTime!.minute,
//     );
//     DateTime thresholdDate = DateTime.now().add(const Duration(hours: 1));
//     print(desiredDate.toIso8601String());
//     print(thresholdDate.toIso8601String());
//     if (desiredDate.isBefore(thresholdDate)) {
//       Get.showSnackbar(GetSnackBar(
//         message: "pick a time at least 1 hr from now".tr,
//         duration: const Duration(milliseconds: 2500),
//       ));
//       return;
//     }
//     toggleLoading(true);
//     Map<String, dynamic> newOrder = {
//       "discription": description.text,
//       "type_vehicle": selectedVehicleType?.id,
//       "start_point": [startAddress!.toJson()],
//       "end_point": [endAddress!.toJson()],
//       "weight": weight.text,
//       "price": int.parse(price.text),
//       "DateTime": desiredDate.toIso8601String(),
//       "with_cover": coveredCar,
//       "other_info": otherInfo.text == "" ? null : otherInfo.text,
//       "payment_methods": formatPayment(),
//     };
//     print(newOrder);
//
//     bool success = await RemoteServices.editOrder(newOrder, order.id);
//
//     if (success) {
//       customerHomeController.refreshOrders();
//       Get.back();
//       Get.back();
//       Get.showSnackbar(GetSnackBar(
//         message: "order edited successfully".tr,
//         duration: const Duration(milliseconds: 2500),
//       ));
//     }
//     toggleLoading(false);
//   }
// }
