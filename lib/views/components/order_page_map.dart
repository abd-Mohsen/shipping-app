import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderPageMap extends StatefulWidget {
  //to prevent the map from reloading when scrolling from view
  final MapController mapController;
  final void Function(bool)? onMapIsReady;
  const OrderPageMap({super.key, required this.mapController, this.onMapIsReady});

  @override
  State<OrderPageMap> createState() => _OrderPageMapState();
}

class _OrderPageMapState extends State<OrderPageMap> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    super.build(context);
    return OSMFlutter(
      controller: widget.mapController,
      mapIsLoading: SpinKitFoldingCube(color: cs.primary),
      onMapIsReady: widget.onMapIsReady,
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
      ),
    );
  }
}
