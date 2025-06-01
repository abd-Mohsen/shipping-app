import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:flutter/material.dart';
import 'package:shipment/services/download_image_service.dart';

import '../constants.dart';
import '../models/vehicle_model.dart';
import '../services/compress_image_service.dart';
import '../services/remote_services.dart';

class MyVehiclesController extends GetxController {
  DriverHomeController? driverHomeController;

  MyVehiclesController({this.driverHomeController});

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
  bool pickedAnImage = false;

  Future pickImage(String source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedImage == null) return;

    pickedAnImage = true;
    pickedImage = await CompressImageService().compressImage(pickedImage);

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
    List<VehicleModel> newItems = await RemoteServices.fetchDriverVehicles() ?? [];
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
    pickedAnImage = false;
    buttonPressed = false;
  }

  void deleteVehicle(int id) async {
    bool res = await RemoteServices.deleteVehicle(
      id,
      _getStorage.read("role"),
    );
    if (res) {
      myVehicles.removeWhere((vehicle) => vehicle.id == id);
      update();
    }
  }

  bool isLoadingImage = false;
  void toggleLoadingImage(bool value) {
    isLoadingImage = value;
    update();
  }

  void prePopulate(VehicleModel vehicle) async {
    toggleLoadingImage(true);
    vehicleOwner.text = vehicle.fullNameOwner;
    licensePlate.text = vehicle.licensePlate;
    selectedVehicleType = vehicle.vehicleTypeInfo;
    registration = await DownloadImageService().downloadImage(kHostIP + vehicle.registrationPhoto);
    toggleLoadingImage(false);
  }

  final GetStorage _getStorage = GetStorage();

  void submit(bool edit) async {
    if (isLoading || isLoadingVehicle || isLoadingSubmit || isLoadingImage) return;
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
    bool success = edit
        ? await RemoteServices.editVehicle(
            vehicleOwner.text,
            selectedVehicleType!.id,
            licensePlate.text,
            File(registration!.path),
            _getStorage.read("role"),
          )
        : await RemoteServices.addVehicle(
            vehicleOwner.text,
            selectedVehicleType!.id,
            licensePlate.text,
            File(registration!.path),
            GetStorage().read("role"),
          );
    if (success) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "the car was added successfully".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      resetForm();
      refreshMyVehicles(); //todo: doesnt refresh everytime
      if (driverHomeController != null) driverHomeController!.getCurrentUser();
    }
    toggleLoadingSubmit(false);
  }
}
