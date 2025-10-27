import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/views/components/my_showcase.dart';
import 'package:shipment/views/tabs/company_employees_tab.dart';
import 'package:shipment/views/tabs/company_vehicles_tab.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';

class CompanyManageTab extends StatefulWidget {
  const CompanyManageTab({super.key});

  @override
  State<CompanyManageTab> createState() => _CompanyManageTabState();
}

class _CompanyManageTabState extends State<CompanyManageTab> {
  //todo: when refreshing, some times employees load before vehicles

  final GlobalKey _showKey1 = GlobalKey();
  final GlobalKey _showKey2 = GlobalKey();

  final GetStorage _getStorage = GetStorage();

  final String storageKey = "showcase_company_manage";

  bool get isEnabled => !_getStorage.hasData(storageKey);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEnabled) ShowCaseWidget.of(context).startShowCase([_showKey1, _showKey2]);
      _getStorage.write(storageKey, true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //CurrentUserController cUC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
            backgroundColor: cs.secondaryContainer,
            iconTheme: IconThemeData(
              color: cs.onSecondaryContainer,
            ),
            // leading: IconButton(
            //   onPressed: () {
            //     cUC.scaffoldKey.currentState!.openDrawer();
            //   },
            //   icon: Icon(
            //     Icons.menu,
            //     color: cs.onSecondaryContainer,
            //   ),
            // ),
            // actions: [
            //   GetBuilder<NotificationsController>(
            //     builder: (innerController) {
            //       return NotificationButton(
            //         showBadge: innerController.unreadCount > 0,
            //         color: cs.onSecondaryContainer,
            //       );
            //     },
            //   ),
            // ],
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
                MyShowcase(
                  globalKey: _showKey1,
                  description: 'here you can view your vehicles, edit them and add new ones'.tr,
                  enabled: isEnabled,
                  child: Tab(
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
                ),
                MyShowcase(
                  globalKey: _showKey2,
                  description: 'here you can view your employees, remove them and manage their status'.tr,
                  enabled: isEnabled,
                  child: Tab(
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
                ),
              ],
            )),
        body: GetBuilder<CompanyHomeController>(
          builder: (controller) {
            return const TabBarView(
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
