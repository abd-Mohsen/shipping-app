import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/current_user_controller.dart';
import 'package:shipment/controllers/invoice_controller.dart';
import 'package:shipment/views/components/invoice_card.dart';

class InvoicesView extends StatelessWidget {
  const InvoicesView({super.key});

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
                        Container(
                          padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              //color: cs.primary,
                              gradient: LinearGradient(
                                colors: [Color.lerp(cs.primary, Colors.white, 0.2)!, cs.primary],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0, 1],
                              )),
                          child: Column(
                            //todo(later): add usd/syp switch and change
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "الرصيد الحالي".tr,
                                    style: tt.labelMedium!.copyWith(color: cs.onPrimary),
                                  ),
                                  if (cUC.currentUser?.wallet != null)
                                    Text(
                                      "${"reserved".tr}:  ${cUC.currentUser?.wallet!.reservedCommission}\$",
                                      style: tt.labelSmall!.copyWith(color: cs.onPrimary),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  "${cUC.currentUser?.wallet != null && cUC.currentUser!.wallet!.balances.isEmpty ? ""
                                      "0" : cUC.currentUser?.wallet?.balances.first.amount}\$",
                                  style: tt.headlineLarge!.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        controller.invoices.isEmpty
                            ? Expanded(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Lottie.asset("assets/animations/simple truck.json", height: 200),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: Center(
                                        child: Text(
                                          "no data, pull down to refresh".tr,
                                          style: tt.titleMedium!
                                              .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
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
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
