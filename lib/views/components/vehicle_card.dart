import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String licensePlate; //todo pass only the model

  const VehicleCard({super.key, required this.licensePlate});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: cs.onSurface,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.local_shipping,
            color: cs.primary,
            size: 35,
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                licensePlate,
                style: tt.titleMedium!.copyWith(color: cs.onSurface),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.6,
                child: Text(
                  "idk",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall!.copyWith(
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
              //SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}
