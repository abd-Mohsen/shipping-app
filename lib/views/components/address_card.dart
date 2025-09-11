import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/my_addresses_controller.dart';
import 'package:shipment/models/my_address_model.dart';
import 'package:shipment/views/components/sheet_details_tile.dart';

import 'blurred_sheet.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:jiffy/jiffy.dart';

class AddressCard extends StatelessWidget {
  final MyAddressModel myAddress;
  final bool isLast;
  final bool selectMode;
  final void Function()? onSelect;
  final void Function() onDelete;

  const AddressCard({
    super.key,
    required this.myAddress,
    required this.isLast,
    required this.onSelect,
    required this.onDelete,
    required this.selectMode,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    MyAddressesController mAC = Get.find();

    return GestureDetector(
      onTap:  selectMode ? onSelect : () {
        showMaterialModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          enableDrag: false,
          builder: (context) => BlurredSheet(
            title: "address".tr,
            confirmText: "ok".tr,
            onConfirm: () {
              Get.back();
            },
            height: MediaQuery.of(context).size.height / 1.8,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SheetDetailsTile(
                  title: "address".tr,
                  subtitle: myAddress.address.toString(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 200,
                      child: OSMFlutter(
                        controller: mAC.mapController,
                        mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                        onMapIsReady: (v) {
                          mAC.selectAddress(myAddress);
                        },
                        osmOption: const OSMOption(
                          zoomOption: ZoomOption(
                            initZoom: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: cs.surface,
              //   width: 0.5,
              // ),
              borderRadius: BorderRadius.circular(20),
              color: cs.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: cs.primary,
                        size: 35,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          myAddress.address.toString(),
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                selectMode
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              thickness: 0.8,
              color: cs.onSurface.withValues(alpha: 0.2),
              indent: 12,
            )
        ],
      ),
    );
  }
}
