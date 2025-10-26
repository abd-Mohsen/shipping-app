import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shipment/controllers/shared_home_controller.dart';

class TempMapPage extends StatelessWidget {
  const TempMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    //TextTheme tt = Theme.of(context).textTheme;
    SharedHomeController sHC = Get.find();

    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: sHC.staticMapController,
            mapIsLoading: SpinKitRing(color: cs.primary),
            onMapIsReady: (v) {
              //
            },
            osmOption: OSMOption(
              isPicker: false,
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(Icons.person, color: cs.primary, size: 40),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(Icons.location_history, color: cs.primary, size: 40),
                ),
              ),
              zoomOption: const ZoomOption(
                //initZoom: 17.65,
                initZoom: 6,
              ),
              roadConfiguration: RoadOption(
                roadColor: cs.primary,
                roadWidth: 4,
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2), // Shadow color
                    blurRadius: 3, // Soften the shadow
                    spreadRadius: 1.5, // Extend the shadow
                    offset: const Offset(1, 1), // Shadow direction (x, y)
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: cs.onSecondaryContainer,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
