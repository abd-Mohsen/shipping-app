import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:shipment/views/components/export_file_sheet.dart';

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
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Center(
                              child: Text(
                                "no data, pull down to refresh".tr,
                                style: tt.titleMedium!.copyWith(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListTile(
                                        tileColor: cs.secondaryContainer,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                                        leading: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.directions_car_filled_rounded, color: cs.primary, size: 30),
                                        ),
                                        title: Text(
                                          "available vehicles".tr,
                                          style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.companyStats!.availableVehicle.toString(),
                                            style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: cs.surface,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListTile(
                                        tileColor: cs.secondaryContainer,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                                        leading: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.checklist_outlined, color: cs.primary, size: 30),
                                        ),
                                        title: Text(
                                          "running orders".tr,
                                          style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.companyStats!.processingOrder.toString(),
                                            style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: cs.surface,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                              Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ListTile(
                                  tileColor: cs.secondaryContainer,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.person, color: cs.primary, size: 30),
                                  ),
                                  title: Text(
                                    "available drivers".tr,
                                    style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      controller.companyStats!.availableDrivers.toString(),
                                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: cs.surface,
                                      width: 0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      enableDrag: false,
                                      builder: (BuildContext context) => Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjusts for keyboard
                                        ),
                                        child: const ExportFileSheet(),
                                      ),
                                    );
                                  },
                                  child: IntrinsicWidth(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E7045),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GetBuilder<CompanyHomeController>(
                                            builder: (con) {
                                              return false
                                                  ? SpinKitThreeBounce(color: Colors.white, size: 25)
                                                  : Text("تصدير ملف إكسل");
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                                          left: BorderSide(width: 2, color: cs.surface),
                                          bottom: BorderSide(width: 2, color: cs.surface),
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
                              const SizedBox(height: 4),
                              Text(
                                "orders taken last week".tr,
                                style: tt.titleMedium!.copyWith(color: cs.onSurface),
                              ),
                              const SizedBox(height: 72),
                              // Visibility(
                              //   visible: controller.companyStats!.ordersPerCity.isNotEmpty,
                              //   child: Column(
                              //     children: [
                              //       SizedBox(
                              //         height: MediaQuery.of(context).size.width / 1.2,
                              //         child: PieChart(
                              //           PieChartData(
                              //             borderData: FlBorderData(show: false),
                              //             //centerSpaceRadius: 0,
                              //             sectionsSpace: 0,
                              //             sections: controller.companyStats!.ordersPerCity
                              //                 .map(
                              //                   (city) => PieChartSectionData(
                              //                     value: city.orderCount.toDouble(),
                              //                     title: city.orderLocationName + "\n ${city.orderCount.toDouble()}",
                              //                     titleStyle: tt.labelMedium!.copyWith(color: cs.onSurface),
                              //                     // gradient: LinearGradient(
                              //                     //   colors: [cs.primary, cs.surface],
                              //                     //   stops: [0.1, 1],
                              //                     // ),
                              //                     color: cs.primary,
                              //                     showTitle: true,
                              //                     radius: 100,
                              //                   ),
                              //                 )
                              //                 .toList(),
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(height: 16),
                              //       Text(
                              //         "orders by governorate",
                              //         style: tt.titleMedium!.copyWith(color: cs.onSurface),
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              //todo: put the chart in a card
                              Visibility(
                                visible: controller.companyStats!.ordersPerCity.isNotEmpty,
                                child: pie.PieChart(
                                  dataMap: controller.companyStats!.decodedOrdersPerCity(),
                                  animationDuration: Duration(milliseconds: 800),
                                  chartLegendSpacing: 32,
                                  chartRadius: MediaQuery.of(context).size.width / 1.5,
                                  colorList: [
                                    const Color(0xfffdcb6e), // Yellow
                                    const Color(0xffe17055), // Orange
                                    const Color(0xffd63031), // Red
                                    const Color(0xffe84393), // Pink
                                    const Color(0xff6c5ce7), // Purple
                                    const Color(0xff0984e3), // Blue
                                    const Color(0xff00cec9), // Teal
                                    const Color(0xff00b894), // Green
                                    const Color(0xff55efc4), // Mint
                                    const Color(0xff74b9ff), // Light Blue
                                    const Color(0xffa29bfe), // Lavender
                                    const Color(0xffdfe6e9), // Light Gray
                                    const Color(0xff636e72), // Dark Gray
                                    const Color(0xff2d3436) // Almost Black
                                  ],
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.disc,
                                  ringStrokeWidth: 32,
                                  centerText: "نسبة الطلبيات \n في المحافظات".tr,
                                  centerTextStyle: tt.labelMedium!.copyWith(color: Colors.black),
                                  legendOptions: LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.bottom,
                                    //showLegends: false,
                                    //legendShape: _BoxShape.circle,
                                    legendTextStyle: tt.titleMedium!.copyWith(color: cs.onSurface),
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValues: true,
                                    showChartValuesInPercentage: true,
                                    showChartValuesOutside: false,
                                    decimalPlaces: 1,
                                  ),

                                  // gradientList: ---To add gradient colors---
                                  // emptyColorGradient: ---Empty Color gradient---
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            );
    });
  }
}
