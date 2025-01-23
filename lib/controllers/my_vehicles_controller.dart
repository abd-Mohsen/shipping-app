import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/models/vehicle_type_model.dart';
import 'package:flutter/material.dart';

import '../services/remote_services.dart';

class MyVehiclesController extends GetxController {
  //todo: dont let user get back if there is no vehicles (handel not loaded yet case)
  List<VehicleTypeModel> vehicles = [];

  @override
  onInit() {
    getVehicleTypes();
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

  void submit() async {
    //check that image is selected
  }
}
