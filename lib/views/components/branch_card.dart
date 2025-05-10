import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/models/branch_model.dart';

class BranchCard extends StatelessWidget {
  final BranchModel branch;
  final bool isSelected;
  final void Function() onTap;

  const BranchCard({
    super.key,
    required this.branch,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 3,
          color: cs.surface,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? cs.primary : cs.onSurface,
                width: isSelected ? 1.5 : 0.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Icon(
                  Icons.location_on_sharp,
                  color: cs.primary,
                  size: 35,
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        branch.name,
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Text(
                        branch.address.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall!.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Text(
                        branch.isActive ? "active".tr : "not active".tr,
                        style: tt.titleSmall!.copyWith(
                          color: branch.isActive ? cs.onSurface.withOpacity(0.8) : cs.error,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
