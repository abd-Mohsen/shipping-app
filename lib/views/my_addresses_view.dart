import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shipment/controllers/edit_order_controller.dart';
import 'package:shipment/controllers/make_order_controller.dart';
import 'package:shipment/controllers/my_addresses_controller.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/address_card.dart';

class MyAddressesView extends StatelessWidget {
  final MakeOrderController? makeOrderController;
  final EditOrderController? editOrderController;
  final bool? isStart;
  const MyAddressesView({
    super.key,
    this.makeOrderController,
    this.editOrderController,
    this.isStart,
  });

  //todo: implement search in map here
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MyAddressesController mAC = Get.put(MyAddressesController(
      makeOrderController: makeOrderController,
      editOrderController: editOrderController,
    ));
    bool selectionMode = makeOrderController != null || editOrderController != null;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          selectionMode ? "select an address".tr : 'my addresses'.tr,
          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
      ),
      floatingActionButton: makeOrderController == null && editOrderController == null
          ? GetBuilder<MyAddressesController>(
              builder: (controller) {
                return FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      enableDrag: false,
                      builder: (context) => OSMFlutter(
                        controller: mAC.mapController,
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
                    ).whenComplete(
                      () {
                        controller.addAddress();
                      },
                    );
                  },
                  foregroundColor: cs.onPrimary,
                  child: controller.isLoadingAdd
                      ? SpinKitRotatingPlain(color: cs.onPrimary, size: 20)
                      : Icon(Icons.add, color: cs.onPrimary),
                );
              },
            )
          : null,
      body: GetBuilder<MyAddressesController>(
        builder: (controller) {
          return controller.isLoading
              ? SpinKitSquareCircle(color: cs.primary)
              : RefreshIndicator(
                  onRefresh: controller.refreshMyAddress,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    itemCount: controller.myAddresses.length,
                    itemBuilder: (context, i) => AddressCard(
                      address: controller.myAddresses[i],
                      selectMode: selectionMode,
                      onDelete: () {
                        controller.deleteAddress(controller.myAddresses[i].id!);
                      },
                      onSelect: () {
                        if (!selectionMode) return;
                        if (makeOrderController != null) {
                          if (isStart!) {
                            makeOrderController!.selectStartAddress(controller.myAddresses[i]);
                          } else {
                            makeOrderController!.selectEndAddress(controller.myAddresses[i]);
                          }
                        } else if (editOrderController != null) {
                          if (isStart!) {
                            editOrderController!.selectStartAddress(controller.myAddresses[i]);
                          } else {
                            editOrderController!.selectEndAddress(controller.myAddresses[i]);
                          }
                        }
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
