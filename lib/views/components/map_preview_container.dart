import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../controllers/shared_home_controller.dart';
import '../temp_map_page.dart';

/// created as a static map to show in driver and customer
class MapPreviewContainer extends StatelessWidget {
  const MapPreviewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    SharedHomeController sHC = Get.find();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
      child: Container(
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => Get.to(() => const TempMapPage()),
          child: Stack(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff0e5aa6), width: 2.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: OSMFlutter(
                    controller: sHC.staticMapController,
                    osmOption: OSMOption(
                      zoomOption: const ZoomOption(initZoom: 6),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: AbsorbPointer(absorbing: true, child: Container(color: Colors.transparent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
