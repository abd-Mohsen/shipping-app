import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:flutter/material.dart';

import '../models/vehicle_model.dart';
import '../services/remote_services.dart';

class MyVehiclesController extends GetxController {
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
  void selectVehicleType(VehicleTypeModel? v) {
    selectedVehicleType = v;
    update();
  }

  XFile? registration;

  Future pickImage(String source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedImage == null) return;

    final fileSize = await pickedImage.length();

    final fileSizeInMB = fileSize / (1024 * 1024);
    if (fileSizeInMB > 5) {
      Get.showSnackbar(GetSnackBar(
        message: 'Image is larger than 5 MB'.tr,
        duration: const Duration(milliseconds: 2500),
      ));
      print('Image is too large (${fileSizeInMB.toStringAsFixed(1)} MB)');
      return;
    }

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
    print("refresh==============");
    myVehicles.clear();
    getMyVehicles();
  }

  void resetForm() {
    vehicleOwner.text = "";
    licensePlate.text = "";
    selectedVehicleType = null;
    registration = null;
    buttonPressed = false;
  }

  void deleteVehicle(int id) async {
    bool res = await RemoteServices.deleteVehicle(id);
    if (res) {
      myVehicles.removeWhere((vehicle) => vehicle.id == id);
      update();
    }
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
      refreshMyVehicles(); //todo: doesnt refresh everytime
    }
    toggleLoadingSubmit(false);
  }
}
