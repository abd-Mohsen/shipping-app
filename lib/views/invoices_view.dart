import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/invoice_controller.dart';
import 'package:shipment/views/components/invoice_card.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/views/components/my_loading_animation.dart';
import 'package:shipment/views/components/my_showcase.dart';
import 'package:showcaseview/showcaseview.dart';

class InvoicesView extends StatefulWidget {
  const InvoicesView({super.key});

  @override
  State<InvoicesView> createState() => _InvoicesViewState();
}

class _InvoicesViewState extends State<InvoicesView> {
  final GlobalKey _showKey1 = GlobalKey();
  final GlobalKey _showKey2 = GlobalKey();

  final GetStorage _getStorage = GetStorage();

  final String storageKey = "showcase_invoices";

  bool get isEnabled => !_getStorage.hasData(storageKey);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isEnabled) {
        await Future.delayed(Duration(milliseconds: 2000));
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
    Get.put(InvoiceController());
    CurrentUserController cUC = Get.find();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Text(
          'payment history'.tr,
          style: tt.titleMedium!.copyWith(color: cs.onSurface),
        ),
        centerTitle: true,
      ),
      body: ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.white],
            //set stops as par your requirement
            stops: [0.92, 1], // 50% transparent, 50% white
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: GetBuilder<InvoiceController>(
          builder: (controller) {
            return controller.isLoading
                ? SpinKitSquareCircle(color: cs.primary)
                : RefreshIndicator(
                    onRefresh: controller.refreshBankDetails,
                    child: Column(
                      children: [
                        MyShowcase(
                          globalKey: _showKey1,
                          description: 'balance explanation'.tr,
                          enabled: isEnabled,
                          child: Container(
                            padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                //color: cs.primary,
                                gradient: LinearGradient(
                                  colors: [Color.lerp(cs.primary, Colors.white, 0.2)!, cs.primary],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0, 1],
                                )),
                            child: GetBuilder<CurrentUserController>(builder: (innerController) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "الرصيد الحالي".tr,
                                        style: tt.labelMedium!.copyWith(color: cs.onPrimary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                      cUC.currentUser?.wallet?.balances.length ?? 0,
                                      (i) => Padding(
                                        padding: EdgeInsets.only(top: i == 0 ? 0 : 12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${cUC.currentUser?.wallet != null && cUC.currentUser!.wallet!.balances.isEmpty ? "0" : cUC.currentUser?.wallet?.balances[i].amount} "
                                              "${cUC.currentUser?.wallet != null && cUC.currentUser!.wallet!.balances.isEmpty ? "" : cUC.currentUser?.wallet?.balances[i].currency.symbol}",
                                              style: tt.titleLarge!.copyWith(
                                                color: cs.onPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                "${"reserved".tr}: ${cUC.currentUser?.wallet != null && cUC.currentUser!.wallet!.balances.isEmpty ? ""
                                                    "0" : cUC.currentUser?.wallet?.balances[i].reservedCommission} "
                                                "${cUC.currentUser?.wallet?.balances[i].currency.symbol}",
                                                style: tt.labelSmall!.copyWith(color: cs.onPrimary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        MyShowcase(
                          globalKey: _showKey2,
                          description: 'here your invoices will be shown when you charge your account'.tr,
                          enabled: isEnabled,
                          child: controller.invoices.isEmpty
                              ? const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 32, bottom: 8),
                                    child: MyLoadingAnimation(),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                    itemCount: controller.invoices.length,
                                    itemBuilder: (context, i) => InvoiceCard(
                                      invoice: controller.invoices[i],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
