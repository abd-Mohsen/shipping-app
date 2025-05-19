import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final permissionDeniedDialog = AlertDialog(
    backgroundColor: Colors.white,
    title: const Text("خدمات الموقع مرفوضة", style: TextStyle(color: Colors.black)),
    content: const Text("يرجى اعطاء اذونات الموقع من اعدادات التطبيق", style: TextStyle(color: Colors.black)),
    actions: [
      TextButton(
          onPressed: () async {
            await AppSettings.openAppSettings();
          },
          child: const Text("فتح الاعدادات", style: TextStyle(color: Colors.red))),
    ],
  );

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      print("already granted permission");
    } else if (status.isDenied) {
      await permission.request().isGranted ? print("permission granted") : Get.dialog(permissionDeniedDialog);
    } else {
      if (permission == Permission.location) {
        Get.dialog(permissionDeniedDialog);
      }
    }
  }
}
