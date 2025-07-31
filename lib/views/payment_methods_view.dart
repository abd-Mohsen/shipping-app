import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/payments_controller.dart';
import 'package:shipment/models/payment_selection_model.dart';

import 'components/bank_details_card.dart';
import 'components/blurred_sheet.dart';
import 'components/branch_card.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        centerTitle: true,
        title: Text(
          "payment methods".tr.toUpperCase(),
          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        ),
        iconTheme: IconThemeData(color: cs.onPrimary),
      ),
      body: GetBuilder<PaymentsController>(
        init: PaymentsController(),
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: BoxDecoration(
                    color: cs.primary,
                  ),
                  child: Icon(
                    controller.iconData,
                    color: cs.onPrimary,
                    size: 100,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  //mainAxisSize: MainAxisSize.min, // Use min size for Column
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 32),
                      child: Text(
                        "How do you want to pay?".tr,
                        style: tt.titleMedium!.copyWith(color: cs.primary),
                      ),
                    ),

                    // Main scrollable content
                    Expanded(
                      child: Center(
                        child: controller.isLoadingSelection
                            ? SpinKitSquareCircle(color: cs.primary)
                            : RefreshIndicator(
                                onRefresh: controller.refreshPaymentSelection,
                                child: controller.selections.isEmpty
                                    ? SizedBox(
                                        height: double.infinity,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 64),
                                              child: Center(
                                                child: Text(
                                                  "no data, pull down to refresh".tr,
                                                  style: tt.titleSmall!.copyWith(
                                                    color: cs.onSurface,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                        itemCount: controller.selections.length,
                                        itemBuilder: (context, i) => PaymentMethodSelectionCard(
                                          paymentSelectionModel: controller.selections[i],
                                          onTap: () {
                                            controller.selectOption(controller.selections[i]);
                                          },
                                          isSelected: controller.selectedOption == controller.selections[i],
                                        ),
                                      ),
                              ),
                      ),
                    ),

                    // Bottom button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: GestureDetector(
                        onTap: controller.selectedOption == null
                            ? null
                            : () async {
                                if (controller.selectedOption!.value == "Cash") {
                                  controller.refreshBranches();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true, // This is key for full height
                                    backgroundColor: cs.surface, // Remove default background
                                    builder: (context) => GetBuilder<PaymentsController>(
                                      builder: (controller) {
                                        return SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.95,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                                  child: Icon(Icons.close, color: cs.error),
                                                ),
                                              ),
                                              controller.isLoadingBranches && controller.page == 1
                                                  ? Center(child: SpinKitSquareCircle(color: cs.primary))
                                                  : Expanded(
                                                      child: RefreshIndicator(
                                                        onRefresh: controller.refreshBranches,
                                                        child: controller.branches.isEmpty
                                                            ? Center(
                                                                child: ListView(
                                                                  shrinkWrap: true,
                                                                  children: [
                                                                    Lottie.asset("assets/animations/simple truck.json",
                                                                        height: 200),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.symmetric(horizontal: 32),
                                                                      child: Center(
                                                                        child: Text(
                                                                          "no data, pull down to refresh".tr,
                                                                          style: tt.titleMedium!.copyWith(
                                                                              color: cs.onSurface,
                                                                              fontWeight: FontWeight.bold),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Column(
                                                                children: [
                                                                  Expanded(
                                                                    child: ListView.builder(
                                                                      controller: controller.scrollController,
                                                                      physics: const AlwaysScrollableScrollPhysics(),
                                                                      padding:
                                                                          const EdgeInsets.symmetric(horizontal: 16),
                                                                      itemCount: controller.branches.length + 1,
                                                                      itemBuilder: (context, i) => i <
                                                                              controller.branches.length
                                                                          ? BranchCard(
                                                                              branch: controller.branches[i],
                                                                              isLast:
                                                                                  i == controller.branches.length - 1,
                                                                            )
                                                                          : Center(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                    vertical: 24),
                                                                                child: controller.hasMore
                                                                                    ? CircularProgressIndicator(
                                                                                        color: cs.primary)
                                                                                    : CircleAvatar(
                                                                                        radius: 5,
                                                                                        backgroundColor: cs.onSurface
                                                                                            .withValues(alpha: 0.7),
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  controller.selectedOption!.value == "Bank Account"
                                      ? controller.refreshBankDetails()
                                      : controller.refreshTransferDetails();
                                  //await Future.delayed(Duration(milliseconds: 300));
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    barrierColor: Colors.black.withValues(alpha: 0.5),
                                    enableDrag: false,
                                    builder: (context) => GetBuilder<PaymentsController>(
                                      builder: (controller) {
                                        return BlurredSheet(
                                          sheetPadding: EdgeInsets.zero,
                                          fontSize: 14,
                                          dynamicContent: true,
                                          title: controller.selectedOption!.value == "Bank Account"
                                              ? "bank payment methods".tr
                                              : "money transfer payment methods".tr,
                                          confirmText: "close".tr,
                                          onConfirm: () {
                                            Get.back();
                                          },
                                          height: MediaQuery.of(context).size.height / 1.5,
                                          content: Expanded(
                                            child: (controller.selectedOption!.value == "Bank Account"
                                                    ? controller.isLoadingBank
                                                    : controller.isLoadingTransfer)
                                                ? SpinKitSquareCircle(color: cs.primary)
                                                : Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: RefreshIndicator(
                                                      onRefresh: controller.refreshBankDetails,
                                                      child: (controller.selectedOption!.value == "Bank Account"
                                                              ? controller.bankDetails.isEmpty
                                                              : controller.transferDetails.isEmpty)
                                                          ? Center(
                                                              child: ListView(
                                                                shrinkWrap: true,
                                                                children: [
                                                                  Lottie.asset("assets/animations/simple truck.json",
                                                                      height: 150),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 32),
                                                                    child: Center(
                                                                      child: Text(
                                                                        "no data, pull down to refresh".tr,
                                                                        style: tt.titleSmall!.copyWith(
                                                                            color: cs.onSurface,
                                                                            fontWeight: FontWeight.bold),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : ListView.builder(
                                                              padding: const EdgeInsets.symmetric(
                                                                  vertical: 12, horizontal: 12),
                                                              itemCount:
                                                                  controller.selectedOption!.value == "Bank Account"
                                                                      ? controller.bankDetails.length
                                                                      : controller.transferDetails.length,
                                                              itemBuilder: (context, i) => PaymentDetailsCard(
                                                                bankDetails:
                                                                    controller.selectedOption!.value == "Bank Account"
                                                                        ? controller.bankDetails[i]
                                                                        : null,
                                                                transferDetails:
                                                                    controller.selectedOption!.value == "Money Transfer"
                                                                        ? controller.transferDetails[i]
                                                                        : null,
                                                                isLast:
                                                                    controller.selectedOption!.value == "Bank Account"
                                                                        ? i == controller.bankDetails.length - 1
                                                                        : i == controller.transferDetails.length - 1,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "browse".tr.toUpperCase(),
                              style: tt.labelMedium!.copyWith(color: cs.onPrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class PaymentMethodSelectionCard extends StatelessWidget {
  final PaymentSelectionModel paymentSelectionModel;
  final void Function() onTap;
  final bool isSelected;

  const PaymentMethodSelectionCard({
    super.key,
    required this.paymentSelectionModel,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: onTap,
        title: Text(
          paymentSelectionModel.name,
          style: tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
        ),
        subtitle: Text(
          paymentSelectionModel.subtitle,
          style: tt.labelSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.45)),
        ),
        trailing: Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 0.6, color: cs.primary),
            color: isSelected ? cs.primary : cs.surface,
          ),
          child: Icon(
            Icons.done,
            color: cs.surface,
            size: 25,
          ),
        ),
      ),
    );
  }
}
