import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipment/models/bank_details_model.dart';
import 'package:shipment/models/branch_model.dart';
import 'package:shipment/models/payment_selection_model.dart';
import 'package:shipment/models/transfer_details_model.dart';
import '../constants.dart';
import '../services/remote_services.dart';

class PaymentsController extends GetxController {
  @override
  onInit() async {
    getPaymentSelection();
    setPaginationListener();
    super.onInit();
  }

  bool _isLoadingBranches = false;
  bool get isLoadingBranches => _isLoadingBranches;
  void toggleLoadingBranches(bool value) {
    _isLoadingBranches = value;
    update();
  }

  List<BranchModel> branches = [];

  ///pagination
  ScrollController scrollController = ScrollController();

  int page = 1, limit = 10;
  bool hasMore = true;

  void setPaginationListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        getBranches();
      }
    });
  }

  void getBranches() async {
    hasMore = true;
    if (isLoadingBranches) return;
    toggleLoadingBranches(true);
    List<BranchModel>? newItems = await RemoteServices.fetchBranches(page: page);
    if (newItems != null) {
      if (newItems.length < limit) hasMore = false;
      branches.addAll(newItems);
      page++;
    } else {
      hasMore = false;
    }
    toggleLoadingBranches(false);
  }

  Future refreshBranches() async {
    page = 1;
    hasMore = true;
    branches.clear();
    getBranches();
  }

  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 33.5101876, longitude: 36.2775732),
  );

  void selectBranch(BranchModel branch) async {
    GeoPoint currPosition = GeoPoint(
      latitude: branch.address.latitude,
      longitude: branch.address.longitude,
    );
    mapController.moveTo(currPosition);
    await Future.delayed(const Duration(milliseconds: 100));
    mapController.addMarker(
      currPosition,
      markerIcon: kMapDefaultMarker,
    );
    update();
  }
  //----------------------bank and transfer details-------------------------

  List<BankDetailsModel> bankDetails = [];

  bool isLoadingBank = false;
  void toggleLoadingBank(bool value) {
    isLoadingBank = value;
    update();
  }

  void getBankDetails() async {
    if (isLoadingBank) return;
    toggleLoadingBank(true);
    List<BankDetailsModel>? newItems = await RemoteServices.fetchBankPaymentsDetails();
    if (newItems != null) {
      bankDetails.addAll(newItems);
    }
    toggleLoadingBank(false);
  }

  Future refreshBankDetails() async {
    bankDetails.clear();
    getBankDetails();
  }

  List<TransferDetailsModel> transferDetails = [];

  bool isLoadingTransfer = false;
  void toggleLoadingTransfer(bool value) {
    isLoadingTransfer = value;
    update();
  }

  void getTransferDetails() async {
    if (isLoadingTransfer) return;
    toggleLoadingTransfer(true);
    List<TransferDetailsModel>? newItems = await RemoteServices.fetchMoneyTransferPaymentsDetails();
    if (newItems != null) {
      transferDetails.addAll(newItems);
    }
    toggleLoadingTransfer(false);
  }

  Future refreshTransferDetails() async {
    transferDetails.clear();
    getTransferDetails();
  }

  //-------------------------------show available-----------------------------------

  List<PaymentSelectionModel> selections = [];

  bool isLoadingSelection = false;
  void toggleLoadingSelection(bool value) {
    isLoadingSelection = value;
    update();
  }

  void getPaymentSelection() async {
    if (isLoadingSelection) return;
    toggleLoadingSelection(true);
    List<PaymentSelectionModel>? newItems = await RemoteServices.fetchPaymentDetailsSelectionOptions();
    if (newItems != null) {
      selections.addAll(newItems);
    }
    toggleLoadingSelection(false);
  }

  Future refreshPaymentSelection() async {
    selections.clear();
    getPaymentSelection();
  }

  PaymentSelectionModel? selectedOption;

  IconData iconData = FontAwesomeIcons.dollarSign;

  void selectOption(PaymentSelectionModel selectedOption) {
    this.selectedOption = selectedOption;
    iconData = selectedOption.value == "Bank Account"
        ? Icons.account_balance
        : selectedOption.value == "Cash"
            ? FontAwesomeIcons.moneyBill
            : FontAwesomeIcons.moneyBillTransfer;
    update();
  }
}
