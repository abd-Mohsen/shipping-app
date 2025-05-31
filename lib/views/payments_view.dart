import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      length: 3,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.secondaryContainer,
          title: Text(
            'payment methods'.tr,
            style: tt.titleSmall!.copyWith(color: cs.onSecondaryContainer),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: cs.primary,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.house,
                    color: cs.onSecondaryContainer,
                    size: 23,
                  ),
                ),
                child: Text(
                  "branches".tr,
                  style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.account_balance,
                    color: cs.onSecondaryContainer,
                    size: 23,
                  ),
                ),
                child: Text(
                  "bank accounts".tr,
                  style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    FontAwesomeIcons.moneyBillTransfer,
                    color: cs.onSecondaryContainer,
                    size: 20,
                  ),
                ),
                child: Text(
                  "money transfer".tr,
                  style: tt.bodySmall!.copyWith(color: cs.onSecondaryContainer),
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
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  itemCount: controller.branches.length,
                                  itemBuilder: (context, i) => BranchCard(
                                    branch: controller.branches[i],
                                    onTap: () {
                                      //
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
                //
                Placeholder(),
              ],
            );
          },
        ),
      ),
    );
  }
}
