import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'dart:math';

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
                      const SizedBox(height: 4),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.person, color: cs.primary, size: 40),
                        ),
                        title: Text(
                          "available drivers".tr,
                          style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "0",
                            style: tt.titleLarge!.copyWith(color: cs.onSurface),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(
                            color: cs.onSurface,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.directions_car_filled, color: cs.primary, size: 40),
                        ),
                        title: Text(
                          "available vehicles".tr,
                          style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "1",
                            style: tt.titleLarge!.copyWith(color: cs.onSurface),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(
                            color: cs.onSurface,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.checklist_outlined, color: cs.primary, size: 40),
                        ),
                        title: Text(
                          "running orders".tr,
                          style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "2",
                            style: tt.titleLarge!.copyWith(color: cs.onSurface),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(
                            color: cs.onSurface,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 20),
                        child: SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              borderData: FlBorderData(
                                border: Border(
                                  top: BorderSide.none,
                                  right: BorderSide.none,
                                  left: BorderSide(width: 2, color: cs.onSurface),
                                  bottom: BorderSide(width: 2, color: cs.onSurface),
                                ),
                              ),
                              groupsSpace: 10,
                              barGroups: List.generate(
                                7,
                                (i) => BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: Random().nextInt(10).toDouble(),
                                      width: 15,
                                      color: cs.primary,
                                    ),
                                  ],
                                ),
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true, // Enable bottom titles
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "San"];
                                      String text = days[value.toInt()];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          text,
                                          style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true, // Enable left titles
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      // Customize the text for Y-axis values
                                      final String text = '${value.toInt()}'; // Example: Display integer values
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          text,
                                          style: tt.labelLarge!.copyWith(color: cs.onSurface),
                                        ),
                                      );
                                    },
                                    interval: 2, // Set the interval between Y-axis labels
                                    reservedSize: 40, // Reserve space for the left titles
                                  ),
                                ),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "orders taken this week",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(height: 72),
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
                                      stops: [0.4, 1],
                                    ),
                                    showTitle: true,
                                    radius: 100,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "orders by governorate",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}
