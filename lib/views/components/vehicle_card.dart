import 'dart:ui';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/controllers/my_vehicles_controller.dart';
import 'package:shipment/models/vehicle_model.dart';
import 'package:shipment/views/components/sheet_details_tile.dart';
import 'add_vehicle_sheet.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final void Function() onDelete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MyVehiclesController mVC = Get.put(MyVehiclesController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cs.secondaryContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 4, // Soften the shadow
              spreadRadius: 1, // Extend the shadow
              offset: const Offset(2, 2), // Shadow direction (x, y)
            ),
          ],
        ),
        child: badges.Badge(
          showBadge: vehicle.registrationStatus == "refused",
          position: badges.BadgePosition.topStart(
            top: 0, // Negative value moves it up
            start: 0, // Negative value moves it left
          ),
          badgeStyle: badges.BadgeStyle(
            shape: badges.BadgeShape.circle,
            badgeColor: kNotificationColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ExpansionTile(
            backgroundColor: cs.secondaryContainer,
            collapsedBackgroundColor: cs.secondaryContainer,
            leading: Icon(
              Icons.directions_car_filled,
              color: vehicle.registrationStatus.toLowerCase() == "verified" ? Colors.green : cs.primary,
              size: 35,
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                vehicle.licensePlate,
                style: tt.titleMedium!.copyWith(color: cs.onSurface),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.6,
                child: Text(
                  vehicle.vehicleTypeInfo.type,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall!.copyWith(
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: cs.surface,
                width: 1,
              ),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: cs.surface,
                width: 0.5,
              ),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SheetDetailsTile(
                          title: "owner name".tr,
                          subtitle: vehicle.fullNameOwner,
                        ),
                      ),
                      Expanded(
                        child: SheetDetailsTile(
                          title: "creation date".tr,
                          subtitle: "${Jiffy.parseFromDateTime(vehicle.createdAt).format(pattern: "d / M / y")}"
                              "  ${Jiffy.parseFromDateTime(vehicle.createdAt).jm}",
                        ),
                      ),
                    ],
                  ),
                  // ListTile(
                  //   title: Text(
                  //     "owner name".tr,
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: tt.titleMedium!.copyWith(
                  //       color: cs.onSurface.withOpacity(1),
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     vehicle.fullNameOwner,
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: tt.titleSmall!.copyWith(
                  //       color: cs.onSurface.withOpacity(0.5),
                  //     ),
                  //   ),
                  // ),
                  SheetDetailsTile(
                    title: "registration status".tr,
                    subtitle: vehicle.registrationStatus.tr,
                    color: vehicle.registrationStatus == "refused" ? cs.error : cs.onSurface,
                  ),
                  // ListTile(
                  //   title: Text(
                  //     "registration status".tr,
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: tt.titleMedium!.copyWith(
                  //       color: cs.onSurface.withOpacity(1),
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: tt.titleSmall!.copyWith(
                  //       color: vehicle.registrationStatus == "refused" ? cs.error : cs.onSurface.withOpacity(0.5),
                  //     ),
                  //   ),
                  // ),
                  // ListTile(
                  //   title: Text(
                  //     "creation date".tr,
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: tt.titleMedium!.copyWith(
                  //       color: cs.onSurface.withOpacity(1),
                  //     ),
                  //   ),
                  //   subtitle: Text(
                  //     maxLines: 2,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: tt.titleSmall!.copyWith(
                  //       color: cs.onSurface.withOpacity(0.5),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: onDelete,
                            child: Text(
                              "delete".tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tt.titleSmall!.copyWith(
                                color: cs.onSurface,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: badges.Badge(
                            showBadge: vehicle.registrationStatus == "refused",
                            position: badges.BadgePosition.topStart(
                              top: 0, // Negative value moves it up
                              start: -6, // Negative value moves it left
                            ),
                            badgeStyle: badges.BadgeStyle(
                              shape: badges.BadgeShape.circle,
                              badgeColor: kNotificationColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                mVC.prePopulate(vehicle);
                                showMaterialModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  enableDrag: true,
                                  builder: (context) => BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: AddVehicleSheet(vehicle: vehicle),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "edit".tr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.titleSmall!
                                      .copyWith(color: cs.onSurface, decoration: TextDecoration.underline),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "$kHostIP${vehicle.registrationPhoto}",
                            headers: const {"Keep-Alive": "timeout=5, max=1000"},
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SpinKitDualRing(
                                    color: cs.primary,
                                    size: 20,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print(error.toString());
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text("Error loading image"),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
