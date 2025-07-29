import 'package:flutter/material.dart';
import 'package:shipment/models/my_address_model.dart';
// import 'package:jiffy/jiffy.dart';

class AddressCard extends StatelessWidget {
  final MyAddressModel myAddress;
  final bool isLast;
  final bool selectMode;
  final void Function()? onSelect;
  final void Function() onDelete;

  const AddressCard({
    super.key,
    required this.myAddress,
    required this.isLast,
    required this.onSelect,
    required this.onDelete,
    required this.selectMode,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onSelect,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: cs.surface,
              //   width: 0.5,
              // ),
              borderRadius: BorderRadius.circular(20),
              color: cs.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: cs.primary,
                      size: 35,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      myAddress.address.toString(),
                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ],
                ),
                selectMode
                    ? SizedBox.shrink()
                    : IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              thickness: 0.8,
              color: cs.onSurface.withValues(alpha: 0.2),
              indent: 12,
            )
        ],
      ),
    );
  }
}
