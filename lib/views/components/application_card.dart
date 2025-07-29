import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipment/models/application_model.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;
  final void Function()? onTapCall;
  final void Function()? onTapAccept;
  final void Function()? onSeePhone;
  final void Function()? onTapRefuse;
  final void Function()? onTapCard;
  final bool? showButtons;
  final bool? isAccepted;
  final bool isLast;
  final bool? showPhone;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.isLast,
    this.onTapCall,
    this.showButtons,
    this.onTapAccept,
    this.onTapRefuse,
    this.onTapCard,
    this.onSeePhone,
    this.isAccepted,
    this.showPhone,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTapCard,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
              decoration: BoxDecoration(
                // border: Border.all(
                //   color: order.status == "processing" ? cs.primary : cs.surface,
                //   width: order.status == "processing" ? 1.5 : 0.5,
                // ),
                // borderRadius: BorderRadius.circular(10),
                color: cs.secondaryContainer,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 37,
                              height: 37,
                              decoration: BoxDecoration(
                                // gradient: LinearGradient(
                                //   colors: [isAccepted ?? true ? cs.primary : Colors.grey, Color(0xffC8C8C8)],
                                //   stops: [0, 1],
                                //   begin: Alignment.topCenter,
                                //   end: Alignment.bottomCenter,
                                // ),
                                color: cs.primary,
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
                                        decoration:
                                            application.isRejected ? TextDecoration.lineThrough : TextDecoration.none,
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
                                        color: cs.onSurface.withValues(alpha: 0.5),
                                        fontSize: 10,
                                        decoration:
                                            application.isRejected ? TextDecoration.lineThrough : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isAccepted ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "accepted".tr,
                            style: tt.labelMedium!.copyWith(color: cs.onSecondaryContainer),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      if (application.canSeePhone &&
                          (showPhone ?? true) &&
                          !application.isRejected &&
                          (isAccepted ?? false))
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
                                  border: Border.all(width: 1.5, color: cs.primaryContainer),
                                ),
                                child: Icon(
                                  CupertinoIcons.phone_fill,
                                  size: 20,
                                  color: cs.primaryContainer,
                                )),
                          ),
                        ),
                    ],
                  ),
                  if ((showButtons ?? false))
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (application.canSeePhone && !application.isRejected)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: GestureDetector(
                                onTap: onTapAccept,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(width: 0.3),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.done,
                                        size: 20,
                                        color: cs.onPrimary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "accept".tr,
                                        style: tt.labelMedium!.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (!application.canSeePhone && !application.isRejected)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: GestureDetector(
                                onTap: onSeePhone,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(width: 0.3),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.contact_phone_rounded,
                                        size: 20,
                                        color: cs.onPrimary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "show number".tr,
                                        style: tt.labelMedium!.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (!application.isRejected && !(isAccepted ?? false))
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              child: GestureDetector(
                                onTap: onTapRefuse,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(width: 0.3),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.close,
                                        size: 20,
                                        color: cs.onPrimary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "refuse".tr,
                                        style: tt.labelMedium!.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
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
                color: cs.onSurface.withValues(alpha: 0.2),
                // indent: MediaQuery.of(context).size.width / 15,
                // endIndent: MediaQuery.of(context).size.width / 15,
              ),
            ),
        ],
      ),
    );
  }
}
