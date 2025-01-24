import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/controllers/order_controller.dart';
import 'package:shipment/models/order_model.dart';

class OrderView extends StatelessWidget {
  final OrderModel order;
  const OrderView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'view order'.toUpperCase(),
          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              //
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: GetBuilder<OrderController>(
        init: OrderController(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.2,
                child: OSMFlutter(
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 4,
                  color: cs.primary,
                  indent: 80,
                  endIndent: 80,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  children: [
                    ListTile(
                      leading: Icon(Icons.text_snippet),
                      title: Text(
                        "description",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        order.discription,
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_pin),
                      title: Text(
                        "from",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        order.startPoint.toString(),
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_pin),
                      title: Text(
                        "to",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        order.endPoint.toString(),
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: Text(
                        "date",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        " ${Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y")}"
                        "  ${Jiffy.parseFromDateTime(order.dateTime).jm}",
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.task_alt,
                        color: Colors.yellowAccent,
                      ),
                      title: Text(
                        "status",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        order.status,
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.monetization_on,
                      ),
                      title: Text(
                        "expected price",
                        style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        order.price,
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
