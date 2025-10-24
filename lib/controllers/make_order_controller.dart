import 'dart:convert';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/my_addresses_controller.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/location_model.dart';
import 'package:shipment/models/make_order_model.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:shipment/services/permission_service.dart';
import 'package:shipment/services/remote_services.dart';

import '../models/currency_model.dart';
import '../models/order_model.dart';
import '../models/weight_unit_model.dart';

class MakeOrderController extends GetxController {
  CustomerHomeController customerHomeController;
  OrderModel? order;

  MakeOrderController({required this.customerHomeController, this.order});

  CurrentUserController cUC = Get.find();

  @override
  void onInit() async {
    await getMakeOrderInfo();
    await PermissionService().requestPermission(Permission.location);
    if (order != null) await prePopulate();
    await loadDraft();
    selectedDate = DateTime.now().add(const Duration(hours: 24));
    selectedTime = TimeOfDay.now();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  @override
  void onClose() {
    if (order == null) saveDraft();
    super.onClose();
  }

  Future loadDraft() async {
    if (!_getStorage.hasData("order_draft") || order != null) return;
    Map<String, dynamic> savedOrder = jsonDecode(_getStorage.read("order_draft"));

    DateTime desiredDate = DateTime.parse(savedOrder["DateTime"]);
    VehicleTypeModel? vehicleType =
        savedOrder["type_vehicle"] == null ? null : VehicleTypeModel.fromJson(savedOrder["type_vehicle"]);

    WeightUnitModel? weightUnit =
        savedOrder["weight_unit"] == null ? null : WeightUnitModel.fromJson(savedOrder["weight_unit"]);
    CurrencyModel? currency = savedOrder["currency"] == null ? null : CurrencyModel.fromJson(savedOrder["currency"]);

    description.text = savedOrder["discription"];
    List<int> selectedPayments = savedOrder["payment_methods"].cast<int>();

    if (vehicleTypes.contains(vehicleType)) selectedVehicleType = vehicleType;

    sourceAddress = savedOrder["start_point"] == null ? null : AddressModel.fromJson(savedOrder["start_point"]);
    targetAddress = savedOrder["end_point"] == null ? null : AddressModel.fromJson(savedOrder["end_point"]);
    weight.text = savedOrder["weight"];
    price.text = savedOrder["price"];
    otherInfo.text = savedOrder["other_info"];
    if (weightUnits.contains(weightUnit)) selectedWeightUnit = weightUnit;
    if (currencies.contains(currency)) selectedCurrency = currency;
    selectedDate = desiredDate;
    selectedTime = TimeOfDay(hour: desiredDate.hour, minute: desiredDate.minute);
    extraInfoSelection = savedOrder["order_extra_info"].cast<bool>();
    await Future.delayed(const Duration(milliseconds: 600));
    paymentMethodController.selectWhere((sI) =>
        selectedPayments.contains(sI.value.id) && paymentMethods.map((p) => p.id).toList().contains(sI.value.id));
    //paymentMethodController.selectWhere((sI) => sI.value.id == 1);
    calculateApplicationCommission();
  }

  void saveDraft() {
    DateTime desiredDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    Map<String, dynamic> order = {
      "discription": description.text,
      "type_vehicle": selectedVehicleType?.toJson(),
      "start_point": sourceAddress?.toJson(),
      "end_point": targetAddress?.toJson(),
      "weight": weight.text,
      "weight_unit": selectedWeightUnit?.toJson(),
      "price": price.text,
      "currency": selectedCurrency?.toJson(),
      "DateTime": desiredDate.toIso8601String(),
      "other_info": otherInfo.text,
      "order_extra_info": extraInfoSelection,
      "payment_methods": paymentMethodController.selectedItems.map((sI) => sI.value.id).toList(),
    };
    _getStorage.write("order_draft", jsonEncode(order));
  }

  GeoPoint? startPosition;
  GeoPoint? endPosition;

  LocationModel? sourceLocation;
  LocationModel? targetLocation;

  void resetForm() {
    paymentMethodController.clearAll();
    sourceAddress = null;
    targetAddress = null;
    description.text = "";
    price.text = "";
    weight.text = "";
    otherInfo.text = "";
    // selectedCurrency = null;
    // selectedWeightUnit = null;
    selectedVehicleType = null;
    selectedDate = DateTime.now().add(const Duration(hours: 24));
    selectedTime = TimeOfDay.now();
    calculateApplicationCommission();
    clearExtraInfo();
    update();
  }

  Future prePopulate() async {
    sourceAddress = order!.startPoint;
    targetAddress = order!.endPoint;
    description.text = order!.description;
    price.text = order!.price.toString();
    weight.text = order!.weight.toString();
    otherInfo.text = order!.otherInfo ?? "";
    selectedCurrency = order!.currency;
    selectedWeightUnit = weightUnits.firstWhere((w) => w.label == order!.weightUnit);
    selectedVehicleType = order!.typeVehicle;
    DateTime orderDate = order!.dateTime;
    selectedDate = orderDate;
    selectedTime = TimeOfDay(hour: orderDate.hour, minute: orderDate.minute);
    //paymentMethodController.selectAll();
    calculateApplicationCommission();
    prePopulateExtraInfo();
    List currentPaymentMethodsValues = order!.paymentMethods.map((p) => p.payment.methodValue).toList();
    await Future.delayed(const Duration(milliseconds: 600));
    paymentMethodController.selectWhere((item) => currentPaymentMethodsValues.contains(item.value.value));
    print(currentPaymentMethodsValues);
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
      if (sourceLocation != null) {
        sourceAddress = sourceLocation!.addressEncoder(
          startPosition!.latitude,
          startPosition!.longitude,
        );
      }
    }
    toggleLoadingSelect1(false);
  }

  void calculateTargetAddress() async {
    toggleLoadingSelect2(true);
    if (endPosition != null) {
      targetLocation = await RemoteServices.getAddressFromLatLng(endPosition!.latitude, endPosition!.longitude);
      if (targetLocation != null) {
        targetAddress = targetLocation!.addressEncoder(
          endPosition!.latitude,
          endPosition!.longitude,
        );
      }
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

  List<PaymentMethodModel> paymentMethods = [];
  List<VehicleTypeModel> vehicleTypes = [];
  List<OrderExtraInfoModel> extraInfo = [];
  List<bool> extraInfoSelection = [];
  List<CurrencyModel> currencies = [];
  List<WeightUnitModel> weightUnits = [];
  double customerCommissionPercentage = 0.0;

  double applicationCommission = 0.0;

  calculateApplicationCommission() {
    applicationCommission =
        double.parse((double.tryParse(price.text) == null) ? "0" : price.text) * (customerCommissionPercentage / 100);
    update();
  }

  VehicleTypeModel? selectedVehicleType;
  void selectVehicleType(VehicleTypeModel? type) {
    selectedVehicleType = type;
    update();
  }

  CurrencyModel? selectedCurrency;
  void selectCurrency(CurrencyModel? currency) {
    selectedCurrency = currency;
    update();
  }

  WeightUnitModel? selectedWeightUnit;
  void selectWeightUnit(WeightUnitModel? weightUnit) {
    selectedWeightUnit = weightUnit;
    update();
  }

  bool isLoadingInfo = false;
  void toggleLoadingInfo(bool value) {
    isLoadingInfo = value;
    update();
  }

  Future getMakeOrderInfo() async {
    toggleLoadingInfo(true);
    MakeOrderModel? model = await RemoteServices.fetchMakeOrderInfo();
    if (model == null) {
      await Future.delayed(const Duration(seconds: 10));
      getMakeOrderInfo();
    } else {
      vehicleTypes = model.vehicleTypes;
      paymentMethods = model.paymentMethods;
      extraInfo = model.orderExtraInfo;
      extraInfoSelection = List.generate(extraInfo.length, (i) => false);
      currencies = model.currencies;
      weightUnits = model.weightUnits;
      customerCommissionPercentage = model.customerCommissionPercentage;

      selectedWeightUnit = weightUnits.first;
      selectedCurrency = currencies.first;
      toggleLoadingInfo(false);
    }
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
    List<int> res = [];
    for (int i = 0; i < extraInfo.length; i++) {
      if (extraInfoSelection[i]) res.add(extraInfo[i].id);
    }
    return res;
  }

  prePopulateExtraInfo() {
    for (int i = 0; i < extraInfo.length; i++) {
      if (order!.extraInfo.contains(extraInfo[i])) extraInfoSelection[i] = true;
    }
  }

  clearExtraInfo() {
    for (int i = 0; i < extraInfo.length; i++) {
      extraInfoSelection[i] = false;
    }
  }

  void makeOrder() async {
    if (isLoading || isLoadingInfo) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    if (sourceAddress == null || targetAddress == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick positions first".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    List<String> syriaNames = ["sy", "syria", "سوريا"];
    if ((sourceLocation != null && !syriaNames.contains(sourceLocation!.country)) ||
        (targetLocation != null && !syriaNames.contains(targetLocation!.country))) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a position in syria".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a date and time first".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
    }
    DateTime desiredDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    // DateTime thresholdDate = DateTime.now().add(const Duration(hours: 1));
    // print(desiredDate.toIso8601String());
    // print(thresholdDate.toIso8601String());
    // if (desiredDate.isBefore(thresholdDate)) {
    //   Get.showSnackbar(GetSnackBar(
    //     message: "pick a time at least 1 hr from now".tr,
    //     duration: const Duration(milliseconds: 2500),
    //   ));
    //   return;
    // }
    toggleLoading(true);
    Map<String, dynamic> order = {
      "discription": description.text,
      "type_vehicle": selectedVehicleType?.id,
      "start_point": sourceAddress!.toJson(),
      "end_point": targetAddress!.toJson(),
      "weight": weight.text,
      "weight_unit": selectedWeightUnit!.value,
      "price": double.parse(price.text),
      "currency": selectedCurrency!.id,
      "DateTime": desiredDate.toIso8601String(),
      "other_info": otherInfo.text == "" ? null : otherInfo.text,
      "order_extra_info": formatExtraInfo(),
      "payment_methods": formatPayment(),
    };
    print(order);
    bool success = await RemoteServices.makeOrder(order);
    if (success) {
      // customerHomeController.refreshOrders();
      // customerHomeController.refreshRecentOrders();
      MyAddressesController mAC = Get.put(MyAddressesController(isInBackground: true));
      mAC.addAddressInBackground(sourceAddress!);
      mAC.addAddressInBackground(targetAddress!);
      mAC.dispose();
      //
      Get.back();
      Get.snackbar(
        "order added successfully".tr,
        "${"order commission".tr} $applicationCommission${selectedCurrency!.symbol}",
        colorText: Colors.white,
        backgroundColor: const Color(0xffFFA500),
        icon: const Icon(Icons.done_all, color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      );
      resetForm();
      cUC.getCurrentUser();
    }
    toggleLoading(false);
  }

  void editOrder() async {
    if (isLoading || isLoadingInfo) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    if (sourceAddress == null || targetAddress == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick positions first".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    List<String> syriaNames = ["sy", "syria", "سوريا"];
    if ((sourceLocation != null && !syriaNames.contains(sourceLocation!.country)) ||
        (targetLocation != null && !syriaNames.contains(targetLocation!.country))) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a position in syria".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick a date and time first".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
    }
    DateTime desiredDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    // DateTime thresholdDate = DateTime.now().add(const Duration(hours: 1));
    // print(desiredDate.toIso8601String());
    // print(thresholdDate.toIso8601String());
    // if (desiredDate.isBefore(thresholdDate)) {
    //   Get.showSnackbar(GetSnackBar(
    //     message: "pick a time at least 1 hr from now".tr,
    //     duration: const Duration(milliseconds: 2500),
    //   ));
    //   return;
    // }
    toggleLoading(true);
    Map<String, dynamic> newOrder = {
      "discription": description.text,
      "type_vehicle": selectedVehicleType?.id,
      "start_point": sourceAddress!.toJson(),
      "end_point": targetAddress!.toJson(),
      "weight": weight.text,
      "weight_unit": selectedWeightUnit!.value,
      "price": double.parse(price.text),
      "currency": selectedCurrency!.id,
      "DateTime": desiredDate.toIso8601String(),
      "other_info": otherInfo.text == "" ? null : otherInfo.text,
      "order_extra_info": formatExtraInfo(),
      "payment_methods": formatPayment(),
    };
    print(newOrder);

    bool success = await RemoteServices.editOrder(newOrder, order!.id);

    if (success) {
      // customerHomeController.refreshOrders();
      // customerHomeController.refreshRecentOrders();
      Get.back();
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "success".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    toggleLoading(false);
  }
}
