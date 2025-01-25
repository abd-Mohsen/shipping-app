import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:flutter/material.dart';

import '../models/vehicle_model.dart';
import '../services/remote_services.dart';

class MyVehiclesController extends GetxController {
  //todo: dont let user get back if there is no vehicles (handel not loaded yet case)
  List<VehicleModel> myVehicles = [];

  @override
  onInit() {
    getVehicleTypes();
    getMyVehicles();
    super.onInit();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool buttonPressed = false;

  TextEditingController licensePlate = TextEditingController();
  TextEditingController vehicleOwner = TextEditingController();

  VehicleTypeModel? selectedVehicleType;
  void selectVehicleType(VehicleTypeModel? user) {
    selectedVehicleType = user;
    update();
  }

  XFile? registration;

  Future pickImage(String source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );
    registration = pickedImage;
    update();
    Get.back();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingSubmit = false;
  bool get isLoadingSubmit => _isLoadingSubmit;
  void toggleLoadingSubmit(bool value) {
    _isLoadingSubmit = value;
    update();
  }

  bool _isLoadingVehicle = false;
  bool get isLoadingVehicle => _isLoadingVehicle;
  void toggleLoadingVehicle(bool value) {
    _isLoadingVehicle = value;
    update();
  }

  List<VehicleTypeModel> vehicleTypes = [];

  void getVehicleTypes() async {
    toggleLoadingVehicle(true);
    List<VehicleTypeModel> newItems = await RemoteServices.fetchVehicleType() ?? [];
    vehicleTypes.addAll(newItems);
    toggleLoadingVehicle(false);
  }

  void getMyVehicles() async {
    toggleLoading(true);
    List<VehicleModel> newItems = await RemoteServices.fetchMyVehicles() ?? [];
    myVehicles.addAll(newItems);
    toggleLoading(false);
  }

  Future<void> refreshMyVehicles() async {
    myVehicles.clear();
    getMyVehicles();
  }

  void resetForm() {
    vehicleOwner.text = "";
    licensePlate.text = "";
    selectedVehicleType = null;
    registration = null;
  }

  void submit() async {
    if (isLoading || isLoadingVehicle || isLoadingSubmit) return;
    buttonPressed = true;
    bool valid = formKey.currentState!.validate();
    if (!valid) return;
    if (registration == null) {
      Get.showSnackbar(GetSnackBar(
        message: "pick images first".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    toggleLoadingSubmit(true);
    bool success = await RemoteServices.addVehicle(
      vehicleOwner.text,
      selectedVehicleType!.id,
      licensePlate.text,
      File(registration!.path),
    );
    if (success) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "the car was added successfully".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      resetForm();
      refreshMyVehicles();
    }
    toggleLoadingSubmit(false);
  }
}
