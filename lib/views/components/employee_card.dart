import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/my_vehicles_controller.dart';
import 'package:shipment/models/employee_model.dart';
import 'package:shipment/models/mini_vehicle_model.dart';
import 'package:shipment/views/components/sheet_details_tile.dart';
import 'package:shipment/views/components/vehicle_selector.dart';

import '../../models/vehicle_model.dart';

class EmployeeCard extends StatelessWidget {
  final EmployeeModel employee;
  final void Function() onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    CompanyHomeController cHC = Get.find();
    MyVehiclesController mVC = Get.find();

    alertDialog({required onPressed, onCancel, required String title, Widget? content}) => AlertDialog(
          title: Text(
            title,
            style: tt.titleMedium!.copyWith(color: cs.onSurface),
          ),
          content: content,
          actions: [
            TextButton(
              onPressed: onPressed,
              child: Text(
                "yes".tr,
                style: tt.titleSmall!.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text(
                "no".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        );

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
        child: ExpansionTile(
          backgroundColor: cs.secondaryContainer,
          collapsedBackgroundColor: cs.secondaryContainer,
          leading: GestureDetector(
            onTap: () {
              //cHC.assignVehicle(mVC.myVehicles.first, employee);
            },
            child: Icon(
              Icons.person,
              color: employee.isAvailable ? Colors.green : cs.primary,
              size: 35,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              employee.user.toString(),
              style: tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              child: Text(
                employee.user.phoneNumber,
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
                        title: "role".tr,
                        subtitle: employee.roleInCompany.type.tr,
                      ),
                    ),
                    Expanded(
                      child: SheetDetailsTile(
                        title: "join date".tr,
                        subtitle: "${Jiffy.parseFromDateTime(employee.joinDate).format(pattern: "d / M / y")}",
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SheetDetailsTile(
                        title: "registration status".tr,
                        subtitle: employee.driver!.licenseStatus.tr,
                        color: employee.driver!.licenseStatus != "verified" ? cs.error : cs.onSurface,
                      ),
                    ),
                    Expanded(
                      child: SheetDetailsTile(
                        title: "حالة السائق".tr,
                        subtitle: !employee.isAvailable ? "not available".tr : "available".tr,
                        color: !employee.isAvailable ? cs.error : cs.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "vehicle".tr,
                    style: tt.labelSmall!.copyWith(color: cs.onSurface.withOpacity(0.5)),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: VehicleSelector<MiniVehicleModel>(
                          enabled: !cHC.isLoadingAssign,
                          selectedItem: employee.vehicle,
                          items: mVC.myVehicles.map((v) => v.toMiniModel()).toList(),
                          title: "no vehicle is assigned".tr,
                          onChanged: (miniV) {
                            if (miniV == null) return;
                            VehicleModel? selectedVehicle = mVC.myVehicles.firstWhere((v) => v.id == miniV.id);
                            //if (selectedVehicle == null) return;
                            if (selectedVehicle.employee != null) {
                              showDialog(
                                context: context,
                                builder: (context) => alertDialog(
                                  onPressed: () {
                                    Get.back();
                                    cHC.assignVehicle(selectedVehicle, employee);
                                  },
                                  onCancel: () {
                                    Get.back();
                                    cHC.refreshMyEmployees();
                                  },
                                  title: "can't assign this vehicle".tr,
                                  content: Text(
                                    "${"vehicle is already assigned to".tr} '${selectedVehicle.employee!.fullName}' "
                                    "${"do you want to assign here anyway and remove it from the other user".tr}",
                                    style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.8)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              );
                            } else {
                              cHC.assignVehicle(selectedVehicle, employee);
                            }
                          },
                        ),
                      ),
                      cHC.isLoadingAssign
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SpinKitThreeBounce(color: cs.onSurface, size: 20),
                            )
                          : IconButton(
                              onPressed: () {
                                cHC.unAssignVehicle(employee);
                              },
                              icon: Icon(
                                Icons.remove,
                                color: cs.error,
                                size: 30,
                              ),
                            )
                    ],
                  ),
                ),
                ListTile(
                  leading: Text(
                    "can accept orders".tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  ),
                  trailing: false
                      ? SpinKitThreeBounce(color: cs.onSurface, size: 20)
                      : Checkbox(
                          value: employee.canAcceptOrders,
                          onChanged: (v) {
                            cHC.toggleEmployee(employee, v!);
                          },
                        ),
                ),
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
                    // Expanded(
                    //   child: Center(
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         mVC.prePopulate(employee);
                    //         showMaterialModalBottomSheet(
                    //           context: context,
                    //           backgroundColor: Colors.transparent,
                    //           barrierColor: Colors.black.withOpacity(0.5),
                    //           enableDrag: true,
                    //           builder: (context) => BackdropFilter(
                    //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    //             child: AddVehicleSheet(vehicle: employee),
                    //           ),
                    //         );
                    //       },
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(4),
                    //         child: Text(
                    //           "edit".tr,
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //           style:
                    //               tt.titleSmall!.copyWith(color: cs.onSurface, decoration: TextDecoration.underline),
                    //           textAlign: TextAlign.start,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
