import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  AlertDialog permissionDeniedDialog(Permission permission) {
    Map<Permission, String> permissionName = {
      Permission.location: "location permissions",
      Permission.storage: "storage permissions",
      Permission.camera: "camera permissions",
    };

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("${permissionName[permission]?.tr ?? "permissions".tr} ${"are denied".tr}",
          style: const TextStyle(color: Colors.black)),
      content: Text("Please enable the permission in app settings".tr, style: const TextStyle(color: Colors.black)),
      actions: [
        TextButton(
            onPressed: () async {
              await AppSettings.openAppSettings();
            },
            child: Text("open settings".tr, style: const TextStyle(color: Colors.red))),
      ],
    );
  }

  Future<bool> requestPermission(Permission permission) async {
    // First check current status
    var status = await permission.status;

    // Handle already granted permissions
    if (status.isGranted || status.isLimited) {
      return true;
    }

    // Request the permission
    final result = await permission.request();

    if (result.isGranted) {
      return true;
    }

    // Check if we should show rationale (Android-specific)
    if (await permission.shouldShowRequestRationale) {
      // User selected "Deny" but not "Don't ask again"
      print("Permission denied (can ask again)");
      return false;
    } else {
      // Either permanently denied or first denial on iOS
      print("Permission permanently denied or first denial on iOS");

      // On iOS, first denial returns false for shouldShowRequestRationale
      // So we need additional checks for iOS
      if (Platform.isIOS && status.isDenied && !status.isPermanentlyDenied) {
        print("First denial on iOS - can ask again");
        return false;
      }

      // True permanent denial
      Get.dialog(permissionDeniedDialog(permission));
      return false;
    }
  }

  // Future<bool> requestPermission(Permission permission) async {
  //   final status = await permission.status;
  //
  //   if (status.isGranted || status.isLimited) {
  //     print("Permission already granted");
  //     return true;
  //   }
  //
  //   // First check if permanently denied
  //   if (status.isPermanentlyDenied) {
  //     print("Permission permanently denied");
  //
  //     Get.dialog(permissionDeniedDialog(permission));
  //
  //     return false;
  //   }
  //
  //   // Request permission if not granted or permanently denied
  //   final result = await permission.request();
  //
  //   if (result.isGranted) {
  //     print("Permission granted");
  //     return true;
  //   } else if (result.isPermanentlyDenied) {
  //     print("Permission permanently denied after request");
  //     Get.dialog(permissionDeniedDialog(permission));
  //
  //     return false;
  //   } else {
  //     // This is the case when user selects "Deny" (not permanently)
  //     print("Permission denied (but can request again)");
  //     return false;
  //   }
  // }
}
