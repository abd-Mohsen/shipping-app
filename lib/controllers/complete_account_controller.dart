import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shipment/services/compress_image_service.dart';

import '../constants.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import 'login_controller.dart';

//todo: re test for all roles
class CompleteAccountController extends GetxController {
  final GetStorage _getStorage = GetStorage();

  dynamic homeController;
  CompleteAccountController({required this.homeController});

  @override
  onInit() async {
    prepopulateImages();
    super.onInit();
  }

  XFile? idFront;
  XFile? idRear;
  XFile? dLicenseFront;
  XFile? dLicenseRear;

  String idStatus = "x";
  String licenseStatus = "x";

  Future<void> prepopulateImages() async {
    toggleLoadingImages(true);
    await homeController.getCurrentUser(refresh: true);
    //idStatus = homeController.currentUser.idStatus;
    licenseStatus = ["company", "customer"].contains(homeController.currentUser.role.type)
        ? "verified"
        : homeController.currentUser.driverInfo!.licenseStatus;
    if (licenseStatus.toLowerCase() == "verified") {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "updated successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    idFront = await downloadImage("$kHostIP${homeController.currentUser.idPhotoFront}");
    idRear = await downloadImage("$kHostIP${homeController.currentUser.idPhotoRare}");
    bool isDriver = !["company", "customer"].contains(homeController.currentUser.role.type);
    if (isDriver) {
      dLicenseFront = await downloadImage("$kHostIP${homeController.currentUser.driverInfo!.drivingLicensePhotoFront}");
      dLicenseRear = await downloadImage("$kHostIP${homeController.currentUser.driverInfo!.drivingLicensePhotoRare}");
    }
    toggleLoadingImages(false);
  }

  bool id1Changed = false;
  bool id2Changed = false;
  bool license1Changed = false;
  bool license2Changed = false;

  Future pickImage(String selectedImage, String source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedImage == null) return;

    pickedImage = await CompressImageService().compressImage(pickedImage);

    if (selectedImage == "ID (front)".tr) {
      idFront = pickedImage;
      id1Changed = true;
    }
    if (selectedImage == "ID (rear)".tr) {
      idRear = pickedImage;
      id2Changed = true;
    }
    if (selectedImage == "driving license (front)".tr) {
      dLicenseFront = pickedImage;
      license1Changed = true;
    }
    if (selectedImage == "driving license (rear)".tr) {
      dLicenseRear = pickedImage;
      license2Changed = true;
    }
    update();
    Get.back();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingImages = false;
  bool get isLoadingImages => _isLoadingImages;
  void toggleLoadingImages(bool value) {
    _isLoadingImages = value;
    update();
  }

  Future<XFile?> downloadImage(String imageUrl) async {
    if (imageUrl.endsWith("null")) return null;
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));

      // Get the document directory path
      final documentDirectory = await getTemporaryDirectory();

      // Generate a unique filename using the image URL's hash code
      final uniqueFileName = 'image_${imageUrl.hashCode}.jpg';

      // Create a file in the temporary directory with the unique filename
      final file = File('${documentDirectory.path}/$uniqueFileName');

      // Write the image bytes to the file
      file.writeAsBytesSync(response.bodyBytes);

      // Create an XFile from the file
      return XFile(file.path);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void submit() async {
    if (isLoading) return;
    if (!id1Changed && !id2Changed && !license1Changed && !license2Changed) {
      Get.showSnackbar(GetSnackBar(
        message: "no new images were selected".tr,
        duration: const Duration(milliseconds: 2500),
      ));
      return;
    }
    toggleLoading(true);
    bool success = await RemoteServices.editProfile(
      idFront: id1Changed ? File(idFront!.path) : null,
      idRear: id2Changed ? File(idRear!.path) : null,
      licenseFront: license1Changed ? File(dLicenseFront!.path) : null,
      licenseRear: license2Changed ? File(dLicenseRear!.path) : null,
    );
    if (success) {
      //Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "updated successfully".tr,
        duration: const Duration(milliseconds: 2500),
        //backgroundColor: Colors.green,
      ));
    }
    toggleLoading(false);
  }

  void logout() async {
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }
}
