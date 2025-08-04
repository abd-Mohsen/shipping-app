import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApplicationCard2 extends StatelessWidget {
  final String title;
  final void Function()? onTapCall;
  final bool? showButtons;
  final bool? isAccepted;
  final bool isLast;

  const ApplicationCard2({
    super.key,
    required this.title,
    required this.isLast,
    this.onTapCall,
    this.showButtons,
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  title,
                                  style: tt.labelMedium!.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
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
