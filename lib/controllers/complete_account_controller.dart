import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shipment/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class CompleteAccountController extends GetxController {
  UserModel user;
  CompleteAccountController({required this.user});

  @override
  onInit() async {
    idFront = await downloadImage("$kHostIP/${user.driverInfo!.idPhotoFront}");
    update();
    super.onInit();
  }

  XFile? idFront;
  XFile? idRear;
  XFile? dLicenseFront;
  XFile? dLicenseRear;

  Future pickImage(String selectedImage, String source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
    );
    if (selectedImage == "ID (front)".tr) idFront = pickedImage;
    if (selectedImage == "ID (rear)".tr) idRear = pickedImage;
    if (selectedImage == "driving license (front)".tr) dLicenseFront = pickedImage;
    if (selectedImage == "driving license (rear)".tr) dLicenseRear = pickedImage;

    update();
    Get.back();
  }

  Future<XFile?> downloadImage(String imageUrl) async {
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));

      // Get the document directory path
      final documentDirectory = await getTemporaryDirectory();

      // Create a file in the temporary directory
      final file = File('${documentDirectory.path}/image.jpg');

      // Write the image bytes to the file
      file.writeAsBytesSync(response.bodyBytes);

      // Create an XFile from the file
      return XFile(file.path);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
