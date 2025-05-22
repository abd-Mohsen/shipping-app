import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/extra_info_model.dart';
import 'package:shipment/models/location_model.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:shipment/services/permission_service.dart';
import 'package:shipment/services/remote_services.dart';

import '../models/order_model.dart';

class MakeOrderController extends GetxController {
  CustomerHomeController customerHomeController;
  OrderModel? order;

  MakeOrderController({required this.customerHomeController, this.order});

  @override
  void onInit() async {
    await getPaymentMethods();
    await getVehicleTypes();
    getExtraInfo();
    await PermissionService().requestPermission(Permission.location); //todo: showing even if accepted
    super.onInit();
  }

  GeoPoint? startPosition;
  GeoPoint? endPosition;

  LocationModel? sourceLocation;
  LocationModel? targetLocation;

  AddressModel? startAddress;
  AddressModel? endAddress;

  void prePopulate() {
    startAddress = order!.startPoint;
    endAddress = order!.endPoint;
    description.text = order!.description;
    price.text = order!.price.toString();
    weight.text = order!.weight;
    otherInfo.text = order!.otherInfo ?? "";
    selectedVehicleType = order!.typeVehicle;
    List currentPaymentMethodsIDs = order!.paymentMethods.map((p) => p.payment.methodName).toList();
    paymentMethodController.selectWhere((item) => currentPaymentMethodsIDs.contains(item.value.name));
    DateTime orderDate = order!.dateTime;
    selectedDate = orderDate;
    selectedTime = TimeOfDay(hour: orderDate.hour, minute: orderDate.minute);
    //coveredCar = order.withCover;
    update();
  }

  void setPosition(GeoPoint? position, bool start) {
    if (position == null) return;
    start ? startPosition = position : endPosition = position;
    start ? calculateStartAddress() : calculateTargetAddress();
    Get.back();
  }

  AddressModel? sourceAddress;
  AddressModel? targetAddress;

  bool _isLoadingSelect1 = false;
  bool get isLoadingSelect1 => _isLoadingSelect1;
  void toggleLoadingSelect1(bool value) {
    _isLoadingSelect1 = value;
    update();
  }

  bool _isLoadingSelect2 = false;
  bool get isLoadingSelect2 => _isLoadingSelect2;
  void toggleLoadingSelect2(bool value) {
    _isLoadingSelect2 = value;
    update();
  }

  void calculateStartAddress() async {
    toggleLoadingSelect1(true);
    if (startPosition != null) {
      sourceLocation = await RemoteServices.getAddressFromLatLng(startPosition!.latitude, startPosition!.longitude);
      if (sourceLocation != null) sourceAddress = sourceLocation!.addressEncoder();
    }
    toggleLoadingSelect1(false);
  }

  void calculateTargetAddress() async {
    toggleLoadingSelect2(true);
    if (endPosition != null) {
      targetLocation = await RemoteServices.getAddressFromLatLng(endPosition!.latitude, endPosition!.longitude);
      if (targetLocation != null) targetAddress = targetLocation!.addressEncoder();
    }
    toggleLoadingSelect2(false);
  }

  void selectStartAddress(AddressModel address) {
    Get.back();
    Get.back();
    // if (Get.routing.current != "/MakeOrderView") Get.back();
    sourceAddress = address;
    update();
  }

  void selectEndAddress(AddressModel address) {
    Get.back();
    Get.back();
    // if (Get.routing.current != "/MakeOrderView") Get.back();
    targetAddress = address;
    update();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController otherInfo = TextEditingController();
  TextEditingController accountName = TextEditingController();
  MultiSelectController<PaymentMethodModel> paymentMethodController = MultiSelectController<PaymentMethodModel>();
  MultiSelectController<VehicleTypeModel> vehicleTypeController = MultiSelectController<VehicleTypeModel>();

  DateTime? selectedDate;
  void setDate(DateTime val) {
    selectedDate = val;
    update();
  }

  TimeOfDay? selectedTime;
  void setTime(TimeOfDay val) {
    selectedTime = val;
    update();
  }

  bool coveredCar = false;
  void toggleCoveredCar() {
    coveredCar = !coveredCar;
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool isBankSelected = false;

  void toggleFields() {
    isBankSelected = paymentMethodController.selectedItems.any((payment) => payment.label == "bank_account");
    // isBankSelected = false;
    // for (final item in paymentMethodController.selectedItems) {
    //   print(item.value.name);
    //   if (item.value.name == "bank_account") {
    //     isBankSelected = true;
    //     break;
    //   }
    // }
    update();
  }

  List<PaymentMethodModel> paymentMethods = [];
  List<VehicleTypeModel> vehicleTypes = [];
  List<String> extraInfo = [];
  List<bool> extraInfoSelection = [];

  VehicleTypeModel? selectedVehicleType;
  void selectVehicleType(VehicleTypeModel? user) {
    selectedVehicleType = user;
    update();
  }

  bool _isLoadingPayment = false;
  bool get isLoadingPayment => _isLoadingPayment;
  void toggleLoadingPayment(bool value) {
    _isLoadingPayment = value;
    update();
  }

  bool _isLoadingVehicle = false;
  bool get isLoadingVehicle => _isLoadingVehicle;
  void toggleLoadingVehicle(bool value) {
    _isLoadingVehicle = value;
    update();
  }

  bool _isLoadingExtra = false;
  bool get isLoadingExtra => _isLoadingExtra;
  void toggleLoadingExtra(bool value) {
    _isLoadingExtra = value;
    update();
  }

  Future getPaymentMethods() async {
    toggleLoadingPayment(true);
    List<PaymentMethodModel> newPaymentMethods = await RemoteServices.fetchPaymentMethods() ?? [];
    paymentMethods.addAll(newPaymentMethods);
    toggleLoadingPayment(false);
  }

  Future getVehicleTypes() async {
    toggleLoadingVehicle(true);
    List<VehicleTypeModel> newItems = await RemoteServices.fetchVehicleType() ?? [];
    vehicleTypes.addAll(newItems);
    toggleLoadingVehicle(false);
  }

  void getExtraInfo() async {
    toggleLoadingExtra(true);
    ExtraInfoModel? newItem = await RemoteServices.fetchOrdersExtraInfo();
    if (newItem != null) {
      extraInfo = newItem.orderExtraInfo;
      extraInfoSelection = List.generate(extraInfo.length, (i) => false);
      print(extraInfo);
    }
    toggleLoadingExtra(false);
  }

  void toggleExtraInfo(int i, bool v) {
    extraInfoSelection[i] = v;
    update();
  }

  List formatPayment() {
    List res = [];
    for (final item in paymentMethodController.selectedItems) {
      res.add({"payment": item.value.id});
    }
    return res;
  }

  List formatExtraInfo() {
    List res = [];
    for (int i = 0; i < extraInfo.length; i++) {
      if (extraInfoSelection[i]) res.add(extraInfo[i]);
    }
    return res;
  }

  void makeOrder() async {
    if (isLoading || isLoadingVehicle || isLoadingPayment) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    if (sourceAddress == null || targetAddress == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick positions first".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    List<String> syriaNames = ["sy", "syria", "سوريا"];
    if ((sourceLocation != null && !syriaNames.contains(sourceLocation!.country)) ||
        (targetLocation != null && !syriaNames.contains(targetLocation!.country))) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a position in syria".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a date and time first".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    DateTime desiredDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    DateTime thresholdDate = DateTime.now().add(const Duration(hours: 1));
    print(desiredDate.toIso8601String());
    print(thresholdDate.toIso8601String());
    if (desiredDate.isBefore(thresholdDate)) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a time at least 1 hr from now".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    toggleLoading(true);
    Map<String, dynamic> order = {
      "discription": description.text,
      "type_vehicle": selectedVehicleType?.id,
      "start_point": [sourceAddress!.toJson()],
      "end_point": [targetAddress!.toJson()],
      //todo: add lat, long here and in order model and in my-addresses and in edit address
      "start_latitude": startPosition?.latitude ?? 0, //TODO: when selecting existing order, i cant get this
      "start_longitude": startPosition?.longitude ?? 0,
      "end_latitude": endPosition?.latitude ?? 0,
      "end_longitude": endPosition?.longitude ?? 0,
      "weight": weight.text,
      "price": int.parse(price.text),
      "DateTime": desiredDate.toIso8601String(),
      "with_cover": coveredCar,
      "other_info": otherInfo.text == "" ? null : otherInfo.text,
      "payment_methods": formatPayment(),
      "order_extra_info": formatExtraInfo(),
    };
    print(order);
    bool success = await RemoteServices.makeOrder(order);
    if (success) {
      customerHomeController.refreshOrders();
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "order added successfully".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoading(false);
  }

  void editOrder() async {
    if (isLoading || isLoadingVehicle || isLoadingPayment) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    if (startAddress == null || endAddress == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick positions first".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    List<String> syriaNames = ["sy", "syria", "سوريا"];
    if ((sourceLocation != null && !syriaNames.contains(sourceLocation!.country)) ||
        (targetLocation != null && !syriaNames.contains(targetLocation!.country))) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a position in syria".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a date and time first".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    DateTime desiredDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    DateTime thresholdDate = DateTime.now().add(const Duration(hours: 1));
    print(desiredDate.toIso8601String());
    print(thresholdDate.toIso8601String());
    if (desiredDate.isBefore(thresholdDate)) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a time at least 1 hr from now".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    toggleLoading(true);
    Map<String, dynamic> newOrder = {
      "discription": description.text,
      "type_vehicle": selectedVehicleType?.id,
      "start_point": [startAddress!.toJson()],
      "end_point": [endAddress!.toJson()],
      "weight": weight.text,
      "price": int.parse(price.text),
      "DateTime": desiredDate.toIso8601String(),
      "with_cover": coveredCar,
      "other_info": otherInfo.text == "" ? null : otherInfo.text,
      "payment_methods": formatPayment(),
    };
    print(newOrder);

    bool success = await RemoteServices.editOrder(newOrder, order!.id);

    if (success) {
      customerHomeController.refreshOrders();
      Get.back();
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "order edited successfully".tr,
        duration: const Duration(milliseconds: 2500),
      ));
    }
    toggleLoading(false);
  }
}
