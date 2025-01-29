import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/driver_home_controller.dart';

class DriverHistoryTab extends StatelessWidget {
  const DriverHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "driver's orders history",
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}
