import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/views/components/my_bottom_bar.dart';
import 'package:shipment/views/components/my_showcase.dart';
import 'package:shipment/views/tabs/company_home_tab.dart';
import 'package:shipment/views/tabs/explore_orders_tab.dart';
import 'package:shipment/views/tabs/my_orders_tab.dart';
import 'package:showcaseview/showcaseview.dart';
import '../constants.dart';
import '../controllers/home_navigation_controller.dart';
import '../controllers/shared_home_controller.dart';
import 'components/my_drawer.dart';
import 'edit_profile_view.dart';
import 'package:get_storage/get_storage.dart';

class CompanyHomeView extends StatefulWidget {
  const CompanyHomeView({super.key});

  @override
  State<CompanyHomeView> createState() => _CompanyHomeViewState();
}

class _CompanyHomeViewState extends State<CompanyHomeView> {
  final GlobalKey _showKey1 = GlobalKey();
  final GlobalKey _showKey2 = GlobalKey();

  final GetStorage _getStorage = GetStorage();

  final String storageKey = "showcase_company_home_view";

  bool get isEnabled => !_getStorage.hasData(storageKey);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isEnabled) {
        await Future.delayed(Duration(milliseconds: 1400));
        ShowCaseWidget.of(context).startShowCase([_showKey1, _showKey2]);
      }
      _getStorage.write(storageKey, true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //ThemeController tC = Get.find();
    HomeNavigationController hNC = Get.find();
    CurrentUserController cUC = Get.find();
    //FilterController fC = Get.put(FilterController());

    //CompanyHomeController hC = Get.put(CompanyHomeController());
    SharedHomeController sHC = Get.put(SharedHomeController());

    // Get.put(NotificationsController());
    // Get.put(OnlineSocketController());
    // Get.put(RefreshSocketController());
    // Get.put(MyVehiclesController());

    //LocaleController lC = Get.find();
    ColorScheme cs = Theme.of(context).colorScheme;
    //TextTheme tt = Theme.of(context).textTheme;

    List<Widget> tabs = [
      const CompanyHomeTab(),
      const MyOrdersTab(),
      //const CompanyStatsTab(),
      //const CompanyManageTab(),
      const ExploreOrdersTab(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (hNC.tabIndex != 0) {
          hNC.changeTab(0);
        } else {
          Get.dialog(kCloseAppDialog());
        }
      },
      child: GetBuilder<HomeNavigationController>(
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            key: cUC.scaffoldKey,
            bottomNavigationBar: MyShowcase(
              globalKey: _showKey2,
              description: 'company bottom bar explanation'.tr,
              enabled: isEnabled,
              child: MyBottomBar(
                onChanged: (i) {
                  controller.changeTab(i);
                  sHC.filterController.clearFilters();
                },
                currentIndex: controller.tabIndex,
              ),
            ),
            // BottomNavigationBar(
            //   items: [
            //     BottomNavigationBarItem(
            //       icon: const Padding(
            //         padding: EdgeInsets.all(2.0),
            //         child: FaIcon(FontAwesomeIcons.house),
            //       ),
            //       label: "home".tr,
            //     ),
            //     BottomNavigationBarItem(
            //       icon: const Padding(
            //         padding: EdgeInsets.all(2.0),
            //         child: FaIcon(FontAwesomeIcons.list),
            //       ),
            //       label: "orders".tr,
            //     ),
            //     // BottomNavigationBarItem(
            //     //   icon: const Padding(
            //     //     padding: EdgeInsets.all(2.0),
            //     //     child: FaIcon(FontAwesomeIcons.chartLine),
            //     //   ),
            //     //   label: "statistics".tr,
            //     // ),
            //     // BottomNavigationBarItem(
            //     //   icon: const Padding(
            //     //     padding: EdgeInsets.all(2.0),
            //     //     child: FaIcon(Icons.manage_accounts),
            //     //   ),
            //     //   label: "manage".tr,
            //     // ),
            //     BottomNavigationBarItem(
            //       icon: const Padding(
            //         padding: EdgeInsets.all(2.0),
            //         child: FaIcon(Icons.search),
            //       ),
            //       label: "explore".tr,
            //     ),
            //   ],
            //   showUnselectedLabels: true,
            //   //height: MediaQuery.of(context).size.height / 11,
            //   backgroundColor: cs.secondaryContainer,
            //   selectedItemColor: cs.primary,
            //   unselectedItemColor: cs.onSurface.withValues(alpha: 0.5),
            //   iconSize: 18,
            //   selectedFontSize: 10,
            //   unselectedFontSize: 10,
            //   elevation: 0,
            //   onTap: (i) {
            //     controller.changeTab(i);
            //     sHC.filterController.clearFilters();
            //   },
            //   currentIndex: controller.tabIndex,
            // ),
            //--------------------------------
            // appBar: controller.tabIndex == 3
            //     ? AppBar(
            //         backgroundColor: cs.secondaryContainer,
            //         iconTheme: IconThemeData(
            //           color: cs.onSecondaryContainer,
            //         ),
            //         title: GetBuilder<CompanyHomeController>(
            //           builder: (controller) {
            //             return Text(
            //               // controller.isLoadingUser || controller.currentUser == null
            //               //     ? 'company'.toUpperCase()
            //               //     : controller.currentUser!.companyInfo!.name,
            //               "manage".tr,
            //               style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
            //               maxLines: 1,
            //               overflow: TextOverflow.ellipsis,
            //             );
            //           },
            //         ),
            //         centerTitle: true,
            //         bottom: controller.tabIndex == 3
            //             ? TabBar(
            //                 indicatorColor: cs.primary,
            //                 indicatorWeight: 4,
            //                 tabs: [
            //                   Tab(
            //                     icon: Padding(
            //                       padding: const EdgeInsets.all(4.0),
            //                       child: Icon(
            //                         Icons.local_shipping_outlined,
            //                         color: cs.onSecondaryContainer,
            //                         size: 23,
            //                       ),
            //                     ),
            //                     child: Text(
            //                       "my vehicles".tr,
            //                       style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
            //                       maxLines: 1,
            //                       overflow: TextOverflow.ellipsis,
            //                     ),
            //                   ),
            //                   Tab(
            //                     icon: Padding(
            //                       padding: const EdgeInsets.all(4.0),
            //                       child: Icon(
            //                         Icons.people_alt_outlined,
            //                         color: cs.onSecondaryContainer,
            //                         size: 23,
            //                       ),
            //                     ),
            //                     child: Text(
            //                       "employees".tr,
            //                       style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
            //                       maxLines: 1,
            //                       overflow: TextOverflow.ellipsis,
            //                     ),
            //                   ),
            //                 ],
            //               )
            //             : null,
            //       )
            //     : null,
            backgroundColor: cs.surface,
            body: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.white],
                      //set stops as par your requirement
                      stops: [0.92, 1], // 50% transparent, 50% white
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: IndexedStack(
                    index: controller.tabIndex,
                    children: tabs,
                  ),
                  // child: tabs[controller.tabIndex],
                ),
                // arrow to indicate that there is a drawer
                Positioned(
                  top: MediaQuery.of(context).size.height / 2,
                  child: GestureDetector(
                    onTap: () {
                      cUC.scaffoldKey.currentState!.openDrawer();
                    },
                    child: MyShowcase(
                      globalKey: _showKey1,
                      description: 'click here to view sidebar'.tr,
                      enabled: isEnabled,
                      child: ClipRect(
                        child: Align(
                          alignment: Directionality.of(context) == TextDirection.rtl
                              ? Alignment.centerLeft // Clip to right half for RTL
                              : Alignment.centerRight, // Clip to left half for LTR
                          widthFactor: 0.5,
                          child: CircleAvatar(
                            backgroundColor: cs.primary.withValues(alpha: 0.7),
                            foregroundColor: cs.onPrimary,
                            child: Padding(
                              padding: Directionality.of(context) == TextDirection.rtl
                                  ? const EdgeInsets.only(right: 16)
                                  : const EdgeInsets.only(left: 16),
                              child: const Icon(Icons.arrow_forward_ios, size: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            drawer: GetBuilder<CurrentUserController>(
              builder: (controller) {
                return MyDrawer(
                  onClose: () {
                    controller.scaffoldKey.currentState!.closeDrawer();
                  },
                  onRefreshUser: () {
                    controller.getCurrentUser();
                  },
                  onEditProfileClick: () {
                    Get.to(() => const EditProfileView());
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
    );
  }
}
