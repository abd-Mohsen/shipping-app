import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/order_controller.dart';
import 'package:shipment/views/components/blurred_sheet.dart';
import 'package:shipment/views/components/input_field.dart';
import 'auth_field.dart';

class AddNoteSheet extends StatelessWidget {
  const AddNoteSheet({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController oC = Get.find();

    return BlurredSheet(
        height: MediaQuery.of(context).size.height / 3,
        content: GetBuilder<OrderController>(
          builder: (controller) {
            return Form(
              key: controller.noteFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: InputField(
                      controller: controller.note,
                      label: "note".tr,
                      textInputAction: TextInputAction.next,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      prefixIcon: Icons.note,
                      validator: (val) {
                        return validateInput(controller.note.text, 1, 10000, "");
                      },
                      onChanged: (val) {
                        controller.noteFormKey.currentState!.validate();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        title: "add note".tr,
        confirmText: "send".tr.toUpperCase(),
        isLoading: oC.isLoadingNote,
        onConfirm: () {
          oC.addNote();
        });
  }
}
