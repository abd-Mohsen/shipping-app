import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/tabs/company_employees_tab.dart';
import 'package:shipment/views/tabs/company_vehicles_tab.dart';

class CompanyManageTab extends StatelessWidget {
  const CompanyManageTab({super.key});

  //todo: when refreshing, some times employees load before vehicles
  @override
  Widget build(BuildContext context) {
    CompanyHomeController hC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: cs.secondaryContainer,
            iconTheme: IconThemeData(
              color: cs.onSecondaryContainer,
            ),
            title: GetBuilder<CompanyHomeController>(
              builder: (controller) {
                return Text(
                  // controller.isLoadingUser || controller.currentUser == null
                  //     ? 'company'.toUpperCase()
                  //     : controller.currentUser!.companyInfo!.name,
                  "manage".tr,
                  style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: cs.primary,
              indicatorWeight: 4,
              tabs: [
                Tab(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: cs.onSecondaryContainer,
                      size: 23,
                    ),
                  ),
                  child: Text(
                    "my vehicles".tr,
                    style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  icon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.people_alt_outlined,
                      color: cs.onSecondaryContainer,
                      size: 23,
                    ),
                  ),
                  child: Text(
                    "employees".tr,
                    style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )),
        body: GetBuilder<CompanyHomeController>(
          builder: (controller) {
            return TabBarView(
              children: [
                CompanyVehiclesTab(),
                CompanyEmployeesTab(),
              ],
            );
          },
        ),
      ),
    );
  }
}
