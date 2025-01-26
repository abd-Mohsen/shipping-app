import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/driver_home_controller.dart';

class DriverExploreTab extends StatelessWidget {
  const DriverExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    DriverHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return ListView(
      children: [
        Center(child: Text("explore available orders by the governorate")),
      ],
    );
  }
}
