import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/make_order_controller.dart';
import 'package:shipment/controllers/my_addresses_controller.dart';
import 'package:get/get.dart';
import 'package:shipment/views/components/address_card.dart';
import 'package:shipment/views/components/my_loading_animation.dart';

import 'components/map_sheet.dart';

class MyAddressesView extends StatelessWidget {
  final MakeOrderController? makeOrderController;
  final bool? isStart;
  const MyAddressesView({
    super.key,
    this.makeOrderController,
    this.isStart,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    Get.put(MyAddressesController(
      makeOrderController: makeOrderController,
    ));
    bool selectionMode = makeOrderController != null;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent, // Add this line
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: cs.surface, // Match your AppBar
        ),
        centerTitle: true,
        title: Text(
          selectionMode ? "select an address".tr : 'my addresses'.tr,
          style: tt.titleMedium!.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          GetBuilder<MyAddressesController>(
            builder: (controller) {
              return controller.isLoading
                  ? SpinKitSquareCircle(color: cs.primary)
                  : RefreshIndicator(
                      onRefresh: controller.refreshMyAddress,
                      child: controller.myAddresses.isEmpty
                          ? const MyLoadingAnimation()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              itemCount: controller.myAddresses.length,
                              itemBuilder: (context, i) => AddressCard(
                                myAddress: controller.myAddresses[i],
                                selectMode: selectionMode,
                                onDelete: () {
                                  controller.deleteAddress(controller.myAddresses[i].id);
                                },
                                onSelect: () {
                                  if (!selectionMode) return;
                                  if (makeOrderController != null) {
                                    if (isStart!) {
                                      makeOrderController!.selectStartAddress(controller.myAddresses[i].address);
                                    } else {
                                      makeOrderController!.selectEndAddress(controller.myAddresses[i].address);
                                    }
                                  }
                                  // else if (editOrderController != null) {
                                  //   if (isStart!) {
                                  //     editOrderController!.selectStartAddress(controller.myAddresses[i]);
                                  //   } else {
                                  //     editOrderController!.selectEndAddress(controller.myAddresses[i]);
                                  //   }
                                  // }
                                },
                                isLast: controller.myAddresses.length - 1 == i,
                              ),
                            ),
                    );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: makeOrderController == null
                ? GetBuilder<MyAddressesController>(
                    builder: (controller) {
                      return FloatingActionButton(
                        heroTag: "my addresses button",
                        onPressed: () {
                          // showModalBottomSheet(
                          //   context: context,
                          //   enableDrag: false,
                          //   builder: (context) => OSMFlutter(
                          //     controller: mAC.mapController,
                          //     mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                          //     osmOption: OSMOption(
                          //       isPicker: true,
                          //       userLocationMarker: UserLocationMaker(
                          //         personMarker: MarkerIcon(
                          //           icon: Icon(Icons.person, color: cs.primary, size: 40),
                          //         ),
                          //         directionArrowMarker: MarkerIcon(
                          //           icon: Icon(Icons.location_history, color: cs.primary, size: 40),
                          //         ),
                          //       ),
                          //       zoomOption: const ZoomOption(
                          //         initZoom: 16,
                          //       ),
                          //     ),
                          //   ),
                          // ).whenComplete(
                          //   () {
                          //     controller.addAddress();
                          //   },
                          // );

                          showMaterialModalBottomSheet(
                            context: context,
                            enableDrag: false,
                            //isScrollControlled: true,
                            builder: (context) => BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: MapSheet(
                                onDone: controller.setPosition,
                              ),
                            ),
                          );
                        },
                        foregroundColor: cs.onPrimary,
                        child: controller.isLoadingAdd
                            ? SpinKitRotatingPlain(color: cs.onPrimary, size: 20)
                            : Icon(Icons.add, color: cs.onPrimary),
                      );
                    },
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
