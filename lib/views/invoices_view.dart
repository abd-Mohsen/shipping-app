import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/invoice_controller.dart';
import 'package:shipment/models/user_model.dart';
import 'package:shipment/views/components/invoice_card.dart';

class InvoicesView extends StatelessWidget {
  final UserModel user;
  const InvoicesView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    InvoiceController iC = Get.put(InvoiceController());

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'payment history'.tr,
          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<InvoiceController>(
        builder: (controller) {
          return controller.isLoading
              ? SpinKitSquareCircle(color: cs.primary)
              : RefreshIndicator(
                  onRefresh: controller.refreshBankDetails,
                  child: controller.invoices.isEmpty
                      ? Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Lottie.asset("assets/animations/simple truck.json", height: 200),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Center(
                                  child: Text(
                                    "no data, pull down to refresh".tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListTile(
                                        tileColor: cs.secondaryContainer,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                                        leading: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.directions_car_filled_rounded, color: cs.primary, size: 30),
                                        ),
                                        title: Text(
                                          "الرصيد الحالي".tr,
                                          style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            user.wallet.balance,
                                            style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: cs.surface,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListTile(
                                        tileColor: cs.secondaryContainer,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                                        leading: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.checklist_outlined, color: cs.primary, size: 30),
                                        ),
                                        title: Text(
                                          "الرصيد المحفوظ".tr,
                                          style: tt.labelSmall!.copyWith(color: cs.onSurface),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            user.wallet.reservedCommission,
                                            style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: cs.surface,
                                            width: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
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
    );
  }
}
