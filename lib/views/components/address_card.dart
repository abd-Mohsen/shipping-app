import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/models/address_model.dart';
import 'package:shipment/models/vehicle_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final void Function() onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.location_pin,
          color: cs.primary,
          size: 30,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            address.toString(),
            style: tt.titleSmall!.copyWith(color: cs.onSurface),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: cs.onSurface,
            width: 1,
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
            size: 25,
          ),
        ),
      ),
    );
  }
}
