import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/models/application_model.dart';
import 'package:shipment/views/order_view.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;
  final void Function()? onTap;
  final bool? showButtons;
  final bool isLast;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.isLast,
    this.onTap,
    this.showButtons,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Get.to(() => OrderView(orderID: application.id));
      },
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
                              colors: [cs.primary, Color(0xffC8C8C8)],
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
                                  style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                          width: 40,
                          height: 40,
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
                  if (showButtons ?? false)
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        application.vehicle.vehicleType.type,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tt.labelSmall!.copyWith(
                          color: cs.onSurface.withOpacity(0.5),
                          fontSize: 10,
                        ),
                      ),
                    )
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
