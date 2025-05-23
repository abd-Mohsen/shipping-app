import 'package:flutter/material.dart';
import 'package:shipment/models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool selectMode;
  final void Function() onDelete;
  final void Function()? onSelect;

  const AddressCard({
    super.key,
    required this.address,
    required this.selectMode,
    required this.onDelete,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onSelect,
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
            width: 0.5,
          ),
        ),
        trailing: selectMode
            ? null
            : IconButton(
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
