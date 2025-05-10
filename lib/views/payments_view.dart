import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/payments_controller.dart';
import 'package:shipment/views/components/bank_details_card.dart';
import 'package:shipment/views/components/branch_card.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    PaymentsController pC = Get.put(PaymentsController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.primary,
          title: Text(
            'payment methods'.tr,
            style: tt.titleMedium!.copyWith(color: cs.onPrimary),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Color(0xff7fff00),
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.house,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text(
                  "branches".tr,
                  style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.account_balance,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text(
                  "bank accounts".tr,
                  style: tt.bodyMedium!.copyWith(color: cs.onPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: GetBuilder<PaymentsController>(
          builder: (controller) {
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                controller.isLoadingBranches
                    ? SpinKitSquareCircle(color: cs.primary)
                    : controller.branches.isEmpty
                        ? RefreshIndicator(
                            onRefresh: controller.refreshBranches,
                            child: Center(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Lottie.asset("assets/animations/simple truck.json", height: 200),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                    child: Center(
                                      child: Text(
                                        "no data, pull down to refresh".tr,
                                        style:
                                            tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: OSMFlutter(
                                  controller: controller.mapController,
                                  mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                                  osmOption: const OSMOption(
                                    zoomOption: ZoomOption(
                                      initZoom: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  itemCount: controller.branches.length,
                                  itemBuilder: (context, i) => BranchCard(
                                    branch: controller.branches[i],
                                    isSelected: controller.selectedBranch == i,
                                    onTap: () {
                                      controller.selectBranch(controller.branches[i], i);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                //
                controller.isLoadingBank
                    ? SpinKitSquareCircle(color: cs.primary)
                    : RefreshIndicator(
                        onRefresh: controller.refreshBankDetails,
                        child: controller.bankDetails.isEmpty
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
                                itemCount: controller.bankDetails.length,
                                itemBuilder: (context, i) => BankDetailsCard(
                                  bankDetails: controller.bankDetails[i],
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
