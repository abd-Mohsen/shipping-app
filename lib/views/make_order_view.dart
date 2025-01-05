import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../controllers/make_order_controller.dart';

class MakeOrderView extends StatelessWidget {
  const MakeOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MakeOrderController mOC = Get.put(MakeOrderController());
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'customer'.toUpperCase(),
          style: tt.headlineSmall!.copyWith(letterSpacing: 2, color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          //
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("choose the staring point"),
            onTap: () {
              Get.bottomSheet(
                enableDrag: false,
                GetBuilder<MakeOrderController>(
                  builder: (controller) {
                    return OSMFlutter(
                      controller: controller.mapController,
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
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
