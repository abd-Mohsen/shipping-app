import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/invoice_controller.dart';
import 'package:shipment/views/components/invoice_card.dart';

class InvoicesView extends StatelessWidget {
  const InvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    InvoiceController iC = Get.put(InvoiceController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.primary,
          title: Text(
            'payment history'.tr,
            style: tt.titleMedium!.copyWith(color: cs.onPrimary),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Color(0xff7fff00),
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.attach_money,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text(
                  "payments".tr,
                  style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.history,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text(
                  "invoices".tr,
                  style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: GetBuilder<InvoiceController>(
          builder: (controller) {
            return TabBarView(
              children: [
                Placeholder(),
                controller.isLoading
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
                                          style: tt.titleMedium!
                                              .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                itemCount: controller.invoices.length,
                                itemBuilder: (context, i) => InvoiceCard(
                                  invoice: controller.invoices[i],
                                ),
                              ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
