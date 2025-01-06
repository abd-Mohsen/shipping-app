import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MapSelector extends StatelessWidget {
  final MapController mapController;
  final bool start;
  final String address;
  final void Function() onClose;
  const MapSelector({
    super.key,
    required this.mapController,
    required this.start,
    required this.address,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          enableDrag: false,
          builder: (context) => OSMFlutter(
            controller: mapController,
            mapIsLoading: SpinKitFoldingCube(color: cs.primary),
            osmOption: OSMOption(
              isPicker: true,
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(Icons.person, color: cs.primary, size: 40),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(Icons.location_history, color: cs.primary, size: 40),
                ),
              ),
              zoomOption: const ZoomOption(
                initZoom: 16,
              ),
            ),
          ),
        ).whenComplete(onClose);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: cs.onSurface,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.location_pin,
              color: cs.primary,
              size: 35,
            ),
            const SizedBox(width: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  start ? "starting point".tr : "destination point".tr,
                  style: tt.titleMedium!.copyWith(color: cs.onSurface),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Text(
                    address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleSmall!.copyWith(
                      color: address == "select location" ? cs.primary : cs.onSurface.withOpacity(0.5),
                      fontWeight: address == "select location" ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
