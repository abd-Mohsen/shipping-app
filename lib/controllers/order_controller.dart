import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:shipment/models/order_model.dart';

class OrderController extends GetxController {
  final OrderModel order;
  OrderController({required this.order});

  @override
  void onInit() {
    setStatusIndex();
    super.onInit();
  }

  MapController mapController = MapController(
    initMapWithUserPosition: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: true,
    ),
  );

  int statusIndex = 0;

  void setStatusIndex() {
    if (order.status == "draft") return;
    statusIndex = statuses.indexOf(order.status);
  }

  List<String> statuses = ["available", "pending", "approved", "processing", "done"];
}
