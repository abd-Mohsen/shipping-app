import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/models/location_model.dart';
import 'package:shipment/models/payment_method_model.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:shipment/services/remote_services.dart';

class MakeOrderController extends GetxController {
  //todo: add location permission if not added automatically (check when entering the app)
  //todo: make initial position the selected position if not null
  //todo: when making order using preexisting address, check if its in syria first (in the 14 govs)

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
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  MapController mapController2 = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  GeoPoint? startPosition;
  GeoPoint? endPosition;

  LocationModel? sourceLocation;
  LocationModel? targetLocation;

  void calculateStartAddress() async {
    // todo: add loading indicator
    if (startPosition == null) return;
    sourceLocation = await RemoteServices.getAddressFromLatLng(startPosition!.latitude, startPosition!.longitude);
    print(sourceLocation?.addressEncoder().toJson());
    update();
  }

  void calculateTargetAddress() async {
    if (endPosition == null) return;
    targetLocation = await RemoteServices.getAddressFromLatLng(endPosition!.latitude, endPosition!.longitude);
    print(targetLocation?.addressEncoder().toJson());
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
    if (sourceLocation == null || targetLocation == null) {
      Get.showSnackbar(const GetSnackBar(
        message: "اختر الموقع أولاً",
        duration: Duration(milliseconds: 2500),
      ));
      return;
    }
    List<String> syriaNames = ["sy", "syria", "سوريا"];
    if (!syriaNames.contains(sourceLocation!.country) || !syriaNames.contains(targetLocation!.country)) {
      Get.showSnackbar(const GetSnackBar(
        message: "اختر موقع في سوريا",
        duration: Duration(milliseconds: 2500),
      ));
      return;
    }
    toggleLoading(true);
    Map<String, dynamic> order = {
      "discription": description.text,
      "type_vehicle": selectedVehicleType?.id,
      "start_point": [sourceLocation!.addressEncoder().toJson()],
      "end_point": [targetLocation!.addressEncoder().toJson()],
      "weight": weight.text,
      "price": int.parse(price.text),
      "DateTime": DateTime.now().toIso8601String(),
      "with_cover": coveredCar,
      "other_info": otherInfo.text == "" ? null : otherInfo.text,
      "payment_methods": formatPayment(),
    };
    print(order);
    bool success = await RemoteServices.makeOrder(order);
    if (success) {
      customerHomeController.refreshOrders();
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: "تم تسجيل الطلبية بنجاح",
        duration: Duration(milliseconds: 2500),
      ));
    }
    toggleLoading(false);
  }
}
