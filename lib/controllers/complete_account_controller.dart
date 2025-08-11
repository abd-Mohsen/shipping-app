import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/services/compress_image_service.dart';
import 'package:shipment/services/download_image_service.dart';

import '../constants.dart';
import '../services/remote_services.dart';

class CompleteAccountController extends GetxController {
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

  String msg = "";

  Future<void> prepopulateImages() async {
    toggleLoadingImages(true);
    await homeController.getCurrentUser(refresh: true);
    //idStatus = homeController.currentUser.idStatus;
    licenseStatus = ["company", "customer"].contains(homeController.currentUser.role.type)
        ? "verified"
        : homeController.currentUser.driverInfo!.licenseStatus;
    if (licenseStatus == "refused") {
      msg = "your data is refused, please select new pictures then submit";
    } else if (licenseStatus == "pending") {
      msg = "your data is under review, please wait or upload new pictures";
    } else {
      msg = "you need to upload required pictures and wait for confirmation";
    }
    if (licenseStatus.toLowerCase() == "verified") {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "updated successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
    }
    final downloadService = DownloadImageService();
    idFront = await downloadService.downloadImage("$kHostIP${homeController.currentUser.idPhotoFront}");
    idRear = await downloadService.downloadImage("$kHostIP${homeController.currentUser.idPhotoRare}");
    bool isDriver = !["company", "customer"].contains(homeController.currentUser.role.type);
    if (isDriver) {
      dLicenseFront = await downloadService
          .downloadImage("$kHostIP${homeController.currentUser.driverInfo!.drivingLicensePhotoFront}");
      dLicenseRear = await downloadService
          .downloadImage("$kHostIP${homeController.currentUser.driverInfo!.drivingLicensePhotoRare}");
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
      prepopulateImages();
      Get.showSnackbar(GetSnackBar(
        message: "updated successfully".tr,
        duration: const Duration(milliseconds: 2500),
        //backgroundColor: Colors.green,
      ));
    }
    toggleLoading(false);
  }
}
