import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/controllers/register_controller.dart';

class IdImageSelector extends StatelessWidget {
  final String title;
  //final void Function() onTap;
  final bool isSubmitted;
  final XFile? image;
  const IdImageSelector({
    super.key,
    required this.title,
    //required this.onTap,
    required this.isSubmitted,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    RegisterController rC = Get.find();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GetBuilder<RegisterController>(builder: (controller) {
        return ListTile(
          //leading: Icon(card),
          title: Text(title, style: tt.titleSmall!.copyWith(color: cs.onSurface)),
          trailing: isSubmitted
              ? const Icon(Icons.task_alt, color: Colors.green)
              : Icon(Icons.add_a_photo, color: cs.primary),
          onTap: () {
            Get.bottomSheet(
              //todo: ask for camera permission
              Container(
                decoration: BoxDecoration(
                  color: cs.background,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                //height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                      child: Text(
                        "$title preview",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: tt.titleLarge!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Center(
                          child: image == null
                              ? Text(
                                  "no photo is selected",
                                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                )
                              : Image.file(File(image!.path)),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.camera,
                        color: cs.onSurface,
                      ),
                      title: Text(
                        image == null ? "take a photo" : "take a new photo",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                      ),
                      onTap: () {
                        controller.pickImage(image, "camera");
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.photo,
                        color: cs.onSurface,
                      ),
                      title: Text(
                        image == null ? "select a photo from gallery" : "select a new photo from gallery",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                      ),
                      onTap: () {
                        controller.pickImage(image, "gallery");
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(
              color: cs.onSurface,
            ),
          ),
        );
      }),
    );
  }
}
