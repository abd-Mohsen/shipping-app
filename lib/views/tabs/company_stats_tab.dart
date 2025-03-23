import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
          : RefreshIndicator(
              onRefresh: controller.getCompanyStats,
              child: controller.companyStats == null
                  ? Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Lottie.asset("assets/animations/stats3.json", height: 200),
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Text(
                                "no data, pull down to refresh".tr,
                                style: tt.titleSmall!.copyWith(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
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
                              const SizedBox(height: 32),
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
                                        controller.companyStats!.lastWeekOrders.values.toList().length,
                                        (i) => BarChartGroupData(
                                          x: i,
                                          barRods: [
                                            BarChartRodData(
                                              toY:
                                                  controller.companyStats!.lastWeekOrders.values.toList()[i].toDouble(),
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
                                              List<String> days = controller.companyStats!.lastWeekOrders.keys.toList();
                                              String text = days[value.toInt()];
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                child: Text(
                                                  text.substring(0, 3),
                                                  style: tt.labelSmall!.copyWith(color: cs.onSurface),
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
                                "orders taken last week",
                                style: tt.titleMedium!.copyWith(color: cs.onSurface),
                              ),
                              const SizedBox(height: 72),
                              Visibility(
                                visible: controller.companyStats!.ordersPerCity.isNotEmpty,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width / 1.2,
                                      child: PieChart(
                                        PieChartData(
                                          borderData: FlBorderData(show: false),
                                          //centerSpaceRadius: 0,
                                          sectionsSpace: 0,
                                          sections: controller.companyStats!.ordersPerCity
                                              .map(
                                                (city) => PieChartSectionData(
                                                  value: city.orderCount.toDouble(),
                                                  title: city.orderLocationName,
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
                          ),
                        ),
                      ],
                    ),
            );
    });
  }
}
