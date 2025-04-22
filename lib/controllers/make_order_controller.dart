import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/location_model.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:shipment/services/remote_services.dart';

class MakeOrderController extends GetxController {
  //todo: add location permission if not added automatically (check when entering the app)

  CustomerHomeController customerHomeController;
  MakeOrderController({required this.customerHomeController});

  @override
  void onInit() {
    getPaymentMethods();
    getVehicleTypes();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        mapController1.listenerMapSingleTapping.addListener(
          () async {
            if (startPosition != null) mapController1.removeMarker(startPosition!);
            startPosition = mapController1.listenerMapSingleTapping.value!;
            await mapController1.addMarker(
              startPosition!,
              markerIcon: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          },
        );
        mapController2.listenerMapSingleTapping.addListener(
          () async {
            if (endPosition != null) mapController2.removeMarker(endPosition!);
            endPosition = mapController2.listenerMapSingleTapping.value!;
            await mapController2.addMarker(
              endPosition!,
              markerIcon: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            );
          },
        );
      },
    );

    super.onInit();
  }

  MapController mapController1 = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: false,
      unFollowUser: true,
    ),
  );

  MapController mapController2 = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: false,
      unFollowUser: true,
    ),
  );

  GeoPoint? startPosition;
  GeoPoint? endPosition;

  LocationModel? sourceLocation;
  LocationModel? targetLocation;

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

  void getPaymentMethods() async {
    toggleLoadingPayment(true);
    List<PaymentMethodModel> newPaymentMethods = await RemoteServices.fetchPaymentMethods() ?? [];
    paymentMethods.addAll(newPaymentMethods);
    toggleLoadingPayment(false);
  }

  void getVehicleTypes() async {
    toggleLoadingVehicle(true);
    List<VehicleTypeModel> newItems = await RemoteServices.fetchVehicleType() ?? [];
    vehicleTypes.addAll(newItems);
    toggleLoadingVehicle(false);
  }

  List formatPayment() {
    List res = [];
    for (final item in paymentMethodController.selectedItems) {
      res.add({"payment": item.value.id});
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
}
