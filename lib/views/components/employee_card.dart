import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/models/employee_model.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(
          Icons.person,
          color: employee.isAvailable ? Colors.green : cs.primary,
          size: 35,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "${employee.user.firstName} ${employee.user.lastName}",
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
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: cs.onSurface,
            width: 1,
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: cs.onSurface,
            width: 0.5,
          ),
        ),
        children: [
          ListTile(
            title: Text(
              "role".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.titleMedium!.copyWith(
                color: cs.onSurface.withOpacity(1),
              ),
            ),
            subtitle: Text(
              employee.user.role.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.titleSmall!.copyWith(
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "status".tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.titleMedium!.copyWith(
                color: cs.onSurface.withOpacity(1),
              ),
            ),
            subtitle: Text(
              employee.isAvailable ? "available".tr : "not available".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.titleSmall!.copyWith(
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          //todo: join date
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
          //     " ${Jiffy.parseFromDateTime(employee.user.).format(pattern: "d / M / y")}"
          //     "  ${Jiffy.parseFromDateTime(vehicle.createdAt).jm}",
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //     style: tt.titleSmall!.copyWith(
          //       color: cs.onSurface.withOpacity(0.5),
          //     ),
          //   ),
          // ),
          ListTile(
            onTap: onDelete,
            title: Text(
              "remove".tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.titleMedium!.copyWith(
                color: Colors.red,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
