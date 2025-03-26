import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/models/vehicle_model.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
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
              "owner name".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.titleMedium!.copyWith(
                color: cs.onSurface.withOpacity(1),
              ),
            ),
            subtitle: Text(
              vehicle.fullNameOwner,
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
              vehicle.registrationStatus.tr, //todo: localize this
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.titleSmall!.copyWith(
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "creation date".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.titleMedium!.copyWith(
                color: cs.onSurface.withOpacity(1),
              ),
            ),
            subtitle: Text(
              " ${Jiffy.parseFromDateTime(vehicle.createdAt).format(pattern: "d / M / y")}"
              "  ${Jiffy.parseFromDateTime(vehicle.createdAt).jm}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.titleSmall!.copyWith(
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),
          ),
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
          Image.network(
            //todo: 404 error from server
            "$kHostIP/ar${vehicle.registrationPhoto}",
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
        ],
      ),
    );
  }
}
