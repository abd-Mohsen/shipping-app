import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/payments_controller.dart';
import 'package:shipment/models/branch_model.dart';
import 'package:shipment/views/components/sheet_details_tile.dart';

import 'blurred_sheet.dart';

class BranchCard extends StatelessWidget {
  final BranchModel branch;
  final bool? isSelected;
  final bool isLast;

  const BranchCard({
    super.key,
    required this.branch,
    this.isSelected,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    PaymentsController pC = Get.find();

    return GestureDetector(
      onTap: !branch.isActive
          ? null
          : () {
              showMaterialModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withValues(alpha: 0.5),
                enableDrag: false,
                builder: (context) => BlurredSheet(
                  title: "branch details".tr,
                  confirmText: "ok".tr,
                  onConfirm: () {
                    Get.back();
                  },
                  height: MediaQuery.of(context).size.height / 1.5,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SheetDetailsTile(
                        title: "branch name".tr,
                        subtitle: branch.name,
                      ),
                      SheetDetailsTile(
                        title: "branch address".tr,
                        subtitle: branch.address.toString(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff0e5aa6), width: 2.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: OSMFlutter(
                              controller: pC.mapController,
                              mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                              onMapIsReady: (v) {
                                pC.selectBranch(branch);
                              },
                              osmOption: const OSMOption(
                                zoomOption: ZoomOption(
                                  initZoom: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: order.status == "processing" ? cs.primary : cs.surface,
                //   width: order.status == "processing" ? 1.5 : 0.5,
                // ),
                // borderRadius: BorderRadius.circular(10),
                color: cs.surface,
              ),
              // padding: const EdgeInsets.all(12),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   color: cs.secondaryContainer,
              //   border: Border.all(
              //     color: isSelected ?? false ? cs.primary : cs.surface,
              //     width: isSelected ?? false ? 1.5 : 0.5,
              //   ),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.2), // Shadow color
              //       blurRadius: 4, // Soften the shadow
              //       spreadRadius: 1, // Extend the shadow
              //       offset: const Offset(2, 2), // Shadow direction (x, y)
              //     ),
              //   ],
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),
                  Center(
                    child: Icon(
                      branch.isActive ? FontAwesomeIcons.shop : FontAwesomeIcons.shopLock,
                      color: branch.isActive ? cs.primary : Colors.grey,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            branch.name,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.6,
                          child: Text(
                            branch.address.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: tt.labelMedium!.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            branch.isActive ? "in service".tr : "out of service".tr,
                            style: tt.labelMedium!.copyWith(
                              color: branch.isActive ? Colors.green : cs.error,
                              fontWeight: branch.isActive ? FontWeight.normal : FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  color: cs.onSurface.withValues(alpha: 0.2),
                  // indent: MediaQuery.of(context).size.width / 15,
                  // endIndent: MediaQuery.of(context).size.width / 15,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
