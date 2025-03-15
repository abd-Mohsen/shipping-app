import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';

class CompanyStatsTab extends StatelessWidget {
  const CompanyStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "company stats",
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}
