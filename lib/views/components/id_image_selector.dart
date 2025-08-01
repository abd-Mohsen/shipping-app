import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shipment/services/permission_service.dart';

class IdImageSelector extends StatelessWidget {
  final String title;
  final void Function() onTapCamera;
  final void Function() onTapGallery;
  final bool isSubmitted;
  final XFile? image;
  final String? uploadStatus;
  final EdgeInsets? padding;
  const IdImageSelector({
    super.key,
    required this.title,
    required this.onTapCamera,
    required this.isSubmitted,
    required this.image,
    required this.onTapGallery,
    this.uploadStatus,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cs.secondaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2), // Shadow color
              blurRadius: 4, // Soften the shadow
              spreadRadius: 1, // Extend the shadow
              offset: const Offset(2, 2), // Shadow direction (x, y)
            ),
          ],
        ),
        child: ListTile(
          //leading: Icon(card),
          title: Text(title, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
          trailing: uploadStatus == null
              ? isSubmitted
                  ? const Icon(Icons.task_alt, color: Colors.green)
                  : Icon(Icons.add_a_photo, color: cs.primaryContainer)
              : uploadStatus!.toLowerCase() == "verified"
                  ? const Icon(Icons.task_alt, color: Colors.green)
                  : uploadStatus!.toLowerCase() == "pending"
                      ? Icon(Icons.watch_later_outlined, color: cs.onSurface)
                      : uploadStatus!.toLowerCase() == "refused"
                          ? Icon(Icons.close, color: cs.error)
                          : Icon(Icons.add_a_photo, color: cs.primaryContainer),
          onTap:
              // uploadStatus != null && uploadStatus!.toLowerCase() == "verified"
              //     ? null
              //     :
              () async {
            bool cameraAllowed = await PermissionService().requestPermission(Permission.camera);
            //bool storageAllowed = await PermissionService().requestPermission(Permission.storage); //todo
            bool storageAllowed = true;
            if (!cameraAllowed || !storageAllowed) return;
            Get.bottomSheet(
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                //height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                      child: Text(
                        "${"preview".tr} $title",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: cs.onSurface,
                      thickness: 1,
                      indent: 50,
                      endIndent: 50,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Center(
                            child: image == null
                                ? Text(
                                    "no photo is selected".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                  )
                                : Image.file(File(image!.path)),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.camera,
                        color: cs.primary,
                      ),
                      title: Text(
                        image == null ? "take photo".tr : "take new photo".tr,
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                      ),
                      onTap: onTapCamera,
                      //     () {
                      //   controller.pickImage(title, "camera");
                      // },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.photo,
                        color: cs.primary,
                      ),
                      title: Text(
                        image == null ? "select photo from gallery".tr : "select new photo from gallery".tr,
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                      ),
                      onTap: onTapGallery,
                    ),
                  ],
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: cs.surface,
            ),
          ),
        ),
      ),
    );
  }
}
