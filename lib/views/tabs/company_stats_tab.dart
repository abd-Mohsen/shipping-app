import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';

class CompanyStatsTab extends StatelessWidget {
  const CompanyStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GetBuilder<CompanyHomeController>(builder: (controller) {
      return controller.isLoadingStats
          ? SpinKitSquareCircle(color: cs.primary)
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        "orders by governorate",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 1.2,
                        child: PieChart(
                          PieChartData(
                            borderData: FlBorderData(show: false),
                            //centerSpaceRadius: 0,
                            sectionsSpace: 0,
                            sections: controller.governorates
                                .map(
                                  (governorate) => PieChartSectionData(
                                    value: 1 / governorate.id,
                                    title: governorate.name,
                                    titleStyle: tt.labelMedium!.copyWith(color: cs.onSurface),
                                    gradient: LinearGradient(
                                      colors: [cs.primary, cs.surface],
                                      stops: [0.2, 1],
                                    ),
                                    showTitle: true,
                                    radius: 100,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}
