import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/notifications_controller.dart';
import 'package:shipment/views/notifications_view.dart';
import 'package:shipment/views/tabs/company_employees_tab.dart';
import 'package:shipment/views/tabs/company_explore_tab.dart';
import 'package:shipment/views/tabs/company_manage_tab.dart';
import 'package:shipment/views/tabs/company_orders_tab.dart';
import 'package:shipment/views/tabs/company_stats_tab.dart';
import 'package:shipment/views/tabs/company_vehicles_tab.dart';
import '../constants.dart';
import '../controllers/filter_controller.dart';
import '../controllers/home_navigation_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/theme_controller.dart';
import 'components/my_drawer.dart';
import 'edit_profile_view.dart';

class CompanyHomeView extends StatelessWidget {
  const CompanyHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    Get.put(NotificationsController());
    HomeNavigationController hNC = Get.put(HomeNavigationController());
    FilterController fC = Get.put(FilterController());
    CompanyHomeController cHC = Get.put(CompanyHomeController(
      homeNavigationController: hNC,
      filterController: fC,
    ));
    LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const CompanyOrdersTab(),
      const CompanyStatsTab(),
      const Placeholder(),
      const CompanyManageTab(),
      const CompanyExploreTab(),
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }
          Get.dialog(kCloseAppDialog());
        },
        child: GetBuilder<CompanyHomeController>(
          builder: (controller) {
            return Scaffold(
              // bottomNavigationBar: NavigationBar(
              //   destinations: [
              //     NavigationDestination(icon: Icon(Icons.directions_car), label: "vehicles".tr),
              //     NavigationDestination(icon: Icon(Icons.home_rounded), label: "home".tr),
              //     NavigationDestination(icon: Icon(Icons.list), label: "orders".tr),
              //     NavigationDestination(icon: Icon(Icons.manage_accounts), label: "employees".tr),
              //   ],
              //   height: MediaQuery.of(context).size.height / 11,
              //   backgroundColor: Get.isDarkMode ? cs.primary : Color(0xffefefef),
              //   indicatorColor: Get.isDarkMode ? cs.surface : cs.primary,
              //   elevation: 10,
              //   onDestinationSelected: (i) {
              //     controller.changeTab(i);
              //   },
              //   selectedIndex: controller.tabIndex,
              // ),
              bottomNavigationBar: SizedBox(
                height: MediaQuery.of(context).size.height / 14,
                child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FaIcon(FontAwesomeIcons.list),
                      ),
                      label: "orders".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FaIcon(FontAwesomeIcons.chartLine),
                      ),
                      label: "statistics".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FaIcon(FontAwesomeIcons.house),
                      ),
                      label: "home".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FaIcon(Icons.manage_accounts),
                      ),
                      label: "manage".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: FaIcon(Icons.search),
                      ),
                      label: "explore".tr,
                    ),
                  ],
                  showUnselectedLabels: true,
                  //height: MediaQuery.of(context).size.height / 11,
                  backgroundColor: cs.secondaryContainer,
                  selectedItemColor: cs.primary,
                  unselectedItemColor: cs.onSurface.withOpacity(0.5),
                  iconSize: 18,
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                  elevation: 0,
                  onTap: (i) {
                    controller.changeTab(i);
                  },
                  currentIndex: controller.tabIndex,
                ),
              ),
              appBar: AppBar(
                backgroundColor: cs.secondaryContainer,
                iconTheme: IconThemeData(
                  color: cs.onSecondaryContainer,
                ),
                title: GetBuilder<CompanyHomeController>(
                  builder: (controller) {
                    return Text(
                      controller.isLoadingUser || controller.currentUser == null
                          ? 'company'.toUpperCase()
                          : controller.currentUser!.companyInfo!.name,
                      style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                centerTitle: true,
                actions: [
                  GetBuilder<NotificationsController>(builder: (controller) {
                    return IconButton(
                      onPressed: () {
                        Get.to(() => const NotificationsView());
                      },
                      icon: Badge(
                        smallSize: 10,
                        backgroundColor: kNotificationColor,
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.notifications,
                          color: cs.onSecondaryContainer,
                        ),
                      ),
                    );
                  })
                ],
                bottom: controller.tabIndex == 3
                    ? TabBar(
                        indicatorColor: cs.primary,
                        indicatorWeight: 4,
                        tabs: [
                          Tab(
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.checklist_outlined,
                                color: cs.onSecondaryContainer,
                                size: 23,
                              ),
                            ),
                            child: Text(
                              "current".tr,
                              style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Tab(
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.search,
                                color: cs.onSecondaryContainer,
                                size: 23,
                              ),
                            ),
                            child: Text(
                              "explore".tr,
                              style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
              backgroundColor: cs.surface,
              body: IndexedStack(
                index: controller.tabIndex,
                children: tabs,
              ),
              drawer: GetBuilder<CompanyHomeController>(
                builder: (controller) {
                  return MyDrawer(
                    onClose: () {
                      controller.scaffoldKey.currentState!.closeDrawer();
                    },
                    onRefreshUser: () {
                      controller.getCurrentUser();
                    },
                    onEditProfileClick: () {
                      Get.to(EditProfileView(user: controller.currentUser!, homeController: cHC));
                    },
                    onLogout: () {
                      controller.logout();
                    },
                    isLoadingUser: controller.isLoadingUser,
                    currentUser: controller.currentUser,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
