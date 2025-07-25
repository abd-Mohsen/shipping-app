import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyBottomBar extends StatelessWidget {
  final void Function(int) onChanged;
  final int currentIndex;
  const MyBottomBar({super.key, required this.onChanged, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    final GetStorage getStorage = GetStorage();
    String role = getStorage.read("role");

    List<IconData> iconsList = role == "customer"
        ? [Icons.home, Icons.list]
        : role == "company"
            ? [Icons.home, Icons.list, Icons.manage_accounts, Icons.search]
            : [Icons.home, Icons.list, Icons.search, Icons.directions_car];

    List<String> titlesList = role == "customer"
        ? ["home".tr, "orders".tr]
        : role == "company"
            ? ["home".tr, "orders".tr, "manage".tr, "explore".tr]
            : ["home".tr, "orders".tr, "explore".tr, "new"];

    return AnimatedBottomNavigationBar.builder(
      backgroundColor: Get.isDarkMode ? cs.secondaryFixed : cs.primary,
      splashRadius: 0,
      itemCount: iconsList.length,
      tabBuilder: (int i, bool isActive) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconsList[i],
              size: 24,
              color: isActive ? cs.primaryContainer : cs.onPrimary.withValues(alpha: 0.7),
            ),
            Text(
              titlesList[i],
              style: tt.labelSmall!.copyWith(
                color: isActive ? cs.primaryContainer : cs.onPrimary.withValues(alpha: 0.7),
              ),
            )
          ],
        );
      },
      elevation: 0,
      gapLocation: ["driver", "company_employee"].contains(role) ? GapLocation.end : GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapWidth: 0,
      notchMargin: 0,
      leftCornerRadius: 0,
      rightCornerRadius: 0,
      onTap: onChanged,
      activeIndex: currentIndex,
    );
  }
}
