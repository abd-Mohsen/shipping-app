import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/models/application_model.dart';
import 'package:shipment/views/order_view.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;
  final void Function()? onTapCall;
  final void Function()? onTapAccept;
  final void Function()? onTapRefuse;
  final bool? showButtons;
  final bool? isAccepted;
  final bool isLast;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.isLast,
    this.onTapCall,
    this.showButtons,
    this.onTapAccept,
    this.onTapRefuse,
    this.isAccepted,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      // onTap: () {
      //   Get.to(() => OrderView(orderID: application.id));
      // },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: order.status == "processing" ? cs.primary : cs.surface,
                //   width: order.status == "processing" ? 1.5 : 0.5,
                // ),
                // borderRadius: BorderRadius.circular(10),
                color: cs.secondaryContainer,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [isAccepted ?? true ? cs.primary : Colors.grey, Color(0xffC8C8C8)],
                              stops: [0, 1],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.person_fill,
                              color: cs.onPrimary,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.2,
                                child: Text(
                                  application.driver.name,
                                  style: tt.labelMedium!.copyWith(
                                    color: cs.onSurface,
                                    decoration: application.deletedAt != null
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Text(
                                  application.vehicle.vehicleType.type,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.labelSmall!.copyWith(
                                    color: cs.onSurface.withOpacity(0.5),
                                    fontSize: 10,
                                    decoration: application.deletedAt != null
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showButtons ?? false)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: GestureDetector(
                        onTap: onTapRefuse,
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 0.3),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: cs.onPrimary,
                            )),
                      ),
                    ),
                  if (showButtons ?? false)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: GestureDetector(
                        onTap: onTapAccept,
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 0.3),
                            ),
                            child: Icon(
                              Icons.done,
                              size: 20,
                              color: cs.onPrimary,
                            )),
                      ),
                    ),
                  if (isAccepted ?? true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: GestureDetector(
                        onTap: onTapCall,
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: cs.secondaryContainer,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 0.3),
                            ),
                            child: Icon(
                              CupertinoIcons.phone,
                              size: 20,
                              color: cs.onSecondaryContainer,
                            )),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                color: cs.onSurface.withOpacity(0.2),
                // indent: MediaQuery.of(context).size.width / 15,
                // endIndent: MediaQuery.of(context).size.width / 15,
              ),
            ),
        ],
      ),
    );
  }
}
