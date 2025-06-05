import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:shipment/views/components/export_file_sheet.dart';
import 'package:shipment/views/components/stats_tile.dart';

class CompanyStatsTab extends StatelessWidget {
  const CompanyStatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent, // Add this line
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: cs.surface, // Match your AppBar
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            //controller.homeNavigationController.changeTab(1);
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: cs.onSurface,
          ),
        ),
        title: Text(
          "statistics".tr,
          style: tt.titleMedium!.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withOpacity(0.5),
                enableDrag: false,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const ExportFileSheet(),
                ),
              );
            },
            icon: FaIcon(
              //FontAwesomeIcons.fileExcel,
              Icons.print,
              //color: const Color(0xFF1E7045),
              color: cs.onSurface,
            ),
          ),
        ],
      ),
      body: GetBuilder<CompanyHomeController>(builder: (controller) {
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
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, right: 20),
                                child: SizedBox(
                                  height: 270,
                                  child: BarChart(
                                    BarChartData(
                                      borderData: FlBorderData(
                                        border: Border(
                                          top: BorderSide.none,
                                          right: BorderSide.none,
                                          // left: BorderSide(width: 2, color: cs.surface),
                                          // bottom: BorderSide(width: 2, color: cs.surface),
                                          left: BorderSide.none,
                                          bottom: BorderSide.none,
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
                                              //color: cs.primary,
                                              gradient: LinearGradient(
                                                colors: [cs.primary, Colors.deepPurple],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                stops: [0.3, 1],
                                              ),
                                              borderRadius: BorderRadius.circular(5),
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
                                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                                child: Text(
                                                  text.substring(0, 3).toUpperCase(),
                                                  style: tt.labelSmall!.copyWith(
                                                    color: cs.onSurface.withOpacity(0.5),
                                                    fontSize: 10,
                                                  ),
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
                                                  style: tt.labelLarge!.copyWith(color: cs.onSurface.withOpacity(0.5)),
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
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "orders taken last week".tr,
                                  style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                                ),
                              ),
                            ],
                          ),
                          //const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatsTile(
                                        title: "available vehicles".tr,
                                        value: controller.companyStats!.availableVehicle.toString(),
                                        iconData: Icons.directions_car_filled_rounded,
                                      ),
                                    ),
                                    Expanded(
                                      child: StatsTile(
                                        title: "running orders".tr,
                                        value: controller.companyStats!.processingOrder.toString(),
                                        iconData: FontAwesomeIcons.truckFast,
                                        iconSize: 27,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: StatsTile(
                                        title: "available drivers".tr,
                                        value: controller.companyStats!.availableDrivers.toString(),
                                        iconData: Icons.people,
                                      ),
                                    ),
                                    Expanded(
                                      child: StatsTile(
                                        title: "governorates".tr,
                                        value: controller.companyStats!.decodedOrdersPerCity(false).length.toString(),
                                        iconData: FontAwesomeIcons.city,
                                        iconSize: 28,
                                      ),
                                    ),
                                  ],
                                ),

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

                                Visibility(
                                  visible: controller.companyStats!.decodedOrdersPerCity(false).isNotEmpty,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: cs.secondaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2), // Shadow color
                                          blurRadius: 4, // Soften the shadow
                                          spreadRadius: 1, // Extend the shadow
                                          offset: Offset(2, 2), // Shadow direction (x, y)
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "governorates coverage".tr,
                                              style: tt.labelMedium!
                                                  .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Divider(color: cs.onSurface.withOpacity(0.2)),
                                        pie.PieChart(
                                          dataMap: controller.companyStats!.decodedOrdersPerCity(false),
                                          animationDuration: Duration(milliseconds: 800),
                                          chartLegendSpacing: 12,
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
                                          // centerText: "نسبة الطلبيات \n في المحافظات".tr,
                                          // centerTextStyle: tt.labelSmall!.copyWith(color: Colors.black),
                                          legendOptions: LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition: LegendPosition.left,
                                            //showLegends: false,
                                            //legendShape: _BoxShape.circle,
                                            legendTextStyle: tt.labelMedium!.copyWith(color: cs.onSurface),
                                          ),
                                          chartValuesOptions: ChartValuesOptions(
                                            showChartValueBackground: true,
                                            showChartValues: true,
                                            showChartValuesInPercentage: true,
                                            showChartValuesOutside: false,
                                            decimalPlaces: 1,
                                            chartValueStyle: tt.labelSmall!.copyWith(
                                              color: Colors.black,
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          // gradientList: ---To add gradient colors---
                                          // emptyColorGradient: ---Empty Color gradient---
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
              );
      }),
    );
  }
}
