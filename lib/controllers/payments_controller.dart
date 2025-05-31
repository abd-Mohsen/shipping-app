import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:shipment/models/bank_details_model.dart';
import 'package:shipment/models/branch_model.dart';
import 'package:shipment/models/transfer_details_model.dart';
import '../constants.dart';
import '../services/remote_services.dart';

class PaymentsController extends GetxController {
  @override
  onInit() async {
    getBranches();
    getPaymentDetails();
    super.onInit();
  }

  bool _isLoadingBranches = false;
  bool get isLoadingBranches => _isLoadingBranches;
  void toggleLoadingBranches(bool value) {
    _isLoadingBranches = value;
    update();
  }

  List<BranchModel> branches = [];

  void getBranches() async {
    //todo: implement pagination if necessary
    toggleLoadingBranches(true);
    List<BranchModel> newItems = await RemoteServices.fetchBranches() ?? [];
    branches.addAll(newItems);
    toggleLoadingBranches(false);
  }

  Future refreshBranches() async {
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

  bool _isLoadingBank = false;
  bool get isLoadingBank => _isLoadingBank;
  void toggleLoadingBank(bool value) {
    _isLoadingBank = value;
    update();
  }

  List<BankDetailsModel> bankDetails = [];
  List<TransferDetailsModel> transferDetails = [];

  void getPaymentDetails() async {
    toggleLoadingBank(true);
    Map? newItems = await RemoteServices.fetchBankDetails();
    if (newItems != null) {
      bankDetails.addAll(newItems["bank"]);
      transferDetails.addAll(newItems["money_transfer"]);
    }
    toggleLoadingBank(false);
  }

  Future refreshPaymentDetails() async {
    bankDetails.clear();
    transferDetails.clear();
    getPaymentDetails();
  }
}
