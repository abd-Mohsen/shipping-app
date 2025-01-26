import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/driver_home_controller.dart';

class DriverHomeTab extends StatelessWidget {
  const DriverHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return ListView(
      children: [
        Center(child: Text("home (put the current order in here)")),
      ],
    );
  }
}
