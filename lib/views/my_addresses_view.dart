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
import 'package:get_storage/get_storage.dart';
import 'package:shipment/views/components/my_showcase.dart';
import 'package:showcaseview/showcaseview.dart';
import '../controllers/map_selector_controller.dart';
import 'components/map_sheet.dart';

class MyAddressesView extends StatefulWidget {
  final MakeOrderController? makeOrderController;
  final bool? isStart;
  const MyAddressesView({
    super.key,
    this.makeOrderController,
    this.isStart,
  });

  @override
  State<MyAddressesView> createState() => _MyAddressesViewState();
}

class _MyAddressesViewState extends State<MyAddressesView> {
  final GlobalKey _showKey1 = GlobalKey();
  final GlobalKey _showKey2 = GlobalKey();

  final GetStorage _getStorage = GetStorage();

  final String storageKey = "showcase_my_addresses";

  bool get isEnabled => !_getStorage.hasData(storageKey) && widget.makeOrderController == null;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEnabled) {
        ShowCaseWidget.of(context).startShowCase([_showKey1, _showKey2]);
      }
      _getStorage.write(storageKey, true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    Get.put(MyAddressesController(
      makeOrderController: widget.makeOrderController,
    ));
    bool selectionMode = widget.makeOrderController != null;
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
        title: MyShowcase(
          globalKey: _showKey1,
          description: 'here you can save and see important addresses to use them later when making aan order'.tr,
          enabled: isEnabled,
          child: Text(
            selectionMode ? "select an address".tr : 'my addresses'.tr,
            style: tt.titleMedium!.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GetBuilder<MyAddressesController>(
            builder: (controller) {
              return controller.isLoading && controller.page == 1
                  ? SpinKitSquareCircle(color: cs.primary)
                  : RefreshIndicator(
                      onRefresh: controller.refreshMyAddress,
                      child: controller.myAddresses.isEmpty
                          ? const MyLoadingAnimation()
                          : ListView.builder(
                              controller: controller.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              itemCount: controller.myAddresses.length + 1,
                              itemBuilder: (context, i) => i < controller.myAddresses.length
                                  ? AddressCard(
                                      myAddress: controller.myAddresses[i],
                                      selectMode: selectionMode,
                                      onDelete: () {
                                        controller.deleteAddress(controller.myAddresses[i].id);
                                      },
                                      onSelect: () {
                                        if (!selectionMode) return;
                                        if (widget.makeOrderController != null) {
                                          if (widget.isStart!) {
                                            widget.makeOrderController!
                                                .selectStartAddress(controller.myAddresses[i].address);
                                          } else {
                                            widget.makeOrderController!
                                                .selectEndAddress(controller.myAddresses[i].address);
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
                                    )
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24),
                                        child: controller.hasMore
                                            ? CircularProgressIndicator(color: cs.primary)
                                            : CircleAvatar(
                                                radius: 5,
                                                backgroundColor: cs.onSurface.withValues(alpha: 0.4),
                                              ),
                                      ),
                                    ),
                            ),
                    );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: widget.makeOrderController == null
                ? GetBuilder<MyAddressesController>(
                    builder: (controller) {
                      return MyShowcase(
                        globalKey: _showKey2,
                        description: 'you can add an address from here'.tr,
                        enabled: isEnabled,
                        child: FloatingActionButton(
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
                            if (controller.isLoadingAdd) return;
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
                            ).then(
                              (_) => Get.delete<MapSelectorController>(),
                            );
                          },
                          foregroundColor: cs.onPrimary,
                          child: controller.isLoadingAdd
                              ? SpinKitRotatingPlain(color: cs.onPrimary, size: 20)
                              : Icon(Icons.add, color: cs.onPrimary),
                        ),
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
