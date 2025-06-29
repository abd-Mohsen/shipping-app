import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/controllers/filter_controller.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
import '../models/governorate_model.dart';
import '../models/order_model_2.dart';
import '../services/remote_services.dart';

class SharedHomeController extends GetxController {
  HomeNavigationController homeNavigationController;
  FilterController filterController;
  SharedHomeController({required this.homeNavigationController, required this.filterController});

  @override
  onInit() {
    String role = _getStorage.read("role");
    getOrders();
    getRecentOrders();
    setPaginationListenerMyOrders();
    setPaginationListenerExploreOrders();
    if (role != "customer") getGovernorates();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  String get roleText {
    String role = _getStorage.read("role");
    if (role == "customer") {
      return "customer";
    } else if (role == "driver") {
      return "driver";
    } else {
      return "company";
    }
  }

  TextEditingController searchQueryMyOrders = TextEditingController();
  TextEditingController searchQueryExploreOrders = TextEditingController();

  List<OrderModel2> myOrders = [];
  List<OrderModel2> currOrders = [];
  List<OrderModel2> recentOrders = [];

  List<String> orderTypes = ["not taken", "taken", "current", "finished"];

  // List<String> orderTypes = ["taken", "accepted", "current", "finished"];

  List<IconData> orderIcons = [
    Icons.done,
    Icons.watch_later,
    Icons.local_shipping,
    Icons.done_all,
  ];

  // List<IconData> orderIcons = [
  //   Icons.watch_later,
  //   Icons.done,
  //   Icons.local_shipping,
  //   Icons.done_all,
  // ];

  List<String> selectedOrderTypes = ["current"];

  void setPaginationListenerMyOrders() {
    myOrdersScrollController.addListener(() {
      if (myOrdersScrollController.position.pixels == myOrdersScrollController.position.maxScrollExtent) {
        getOrders();
      }
    });
  }

  void setPaginationListenerExploreOrders() {
    exploreOrdersScrollController.addListener(() {
      if (exploreOrdersScrollController.position.pixels == exploreOrdersScrollController.position.maxScrollExtent) {
        getExploreOrders();
      }
    });
  }

  void setOrderType(String? type, bool clear, {bool selectAll = false}) {
    if (type == null) return;
    if (!selectAll) selectedOrderTypes.clear();
    if (clear) {
      //selectedOrderTypes.clear();
      homeNavigationController.changeTab(1);
    }
    if (selectAll) {
      selectedOrderTypes.length == orderTypes.length
          ? selectedOrderTypes.clear()
          : selectedOrderTypes = List.from(orderTypes);
    } else {
      selectedOrderTypes.contains(type) ? selectedOrderTypes.remove(type) : selectedOrderTypes.add(type);
    }
    refreshOrders();
  }

  ///pagination
  ScrollController myOrdersScrollController = ScrollController();
  ScrollController exploreOrdersScrollController = ScrollController();

  int page = 1, limit = 10;
  bool hasMore = true;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  Future getOrders({bool showLoading = true}) async {
    hasMore = true;
    if (isLoading) return;
    if (showLoading) toggleLoading(true);
    List<String> typesToFetch = [];
    if (selectedOrderTypes.contains("not taken")) typesToFetch.addAll(["available", "draft"]);
    if (selectedOrderTypes.contains("taken")) typesToFetch.addAll(["pending", "approved", "waiting_approval"]);
    if (selectedOrderTypes.contains("current")) typesToFetch.addAll(["processing"]);
    if (selectedOrderTypes.contains("finished")) typesToFetch.addAll(["done", "canceled"]);
    // if (selectedOrderTypes.contains("accepted")) typesToFetch.addAll(["approved"]); //todo
    // if (selectedOrderTypes.contains("taken")) typesToFetch.addAll(["pending", "waiting_approval"]);
    List<OrderModel2>? newItems = await RemoteServices.fetchMyOrders(
      types: typesToFetch,
      role: roleText,
      page: page,
      searchQuery: searchQueryMyOrders.text.trim(),
      minPrice: filterController.minPrice == filterController.sliderMinPrice ? null : filterController.minPrice,
      maxPrice: filterController.maxPrice == filterController.sliderMaxPrice ? null : filterController.maxPrice,
      vehicleType: filterController.selectedVehicleType?.id,
      governorate: filterController.selectedGovernorate?.id,
      currency: filterController.selectedCurrency?.id,
    );
    if (newItems != null) {
      if (newItems.length < limit) hasMore = false;
      myOrders.addAll(newItems);
      page++;
    } else {
      hasMore = false;
    }
    if (showLoading) toggleLoading(false);
  }

  Future<void> refreshOrders({bool showLoading = true}) async {
    page = 1;
    hasMore = true;
    myOrders.clear();
    await getOrders(showLoading: showLoading);
  }

  Timer? _debounceMyOrders;
  searchMyOrders() {
    if (_debounceMyOrders?.isActive ?? false) _debounceMyOrders?.cancel();
    _debounceMyOrders = Timer(const Duration(milliseconds: 500), () {
      refreshOrders();
    });
  }

  Timer? _debounceExploreOrders;
  search({required bool explore}) {
    if (_debounceExploreOrders?.isActive ?? false) _debounceExploreOrders?.cancel();
    _debounceExploreOrders = Timer(const Duration(milliseconds: 500), () {
      refreshExploreOrders();
    });
  }

  //-------------------------------- recent ---------------------------------

  bool _isLoadingRecent = false;
  bool get isLoadingRecent => _isLoadingRecent;
  void toggleLoadingRecent(bool value) {
    _isLoadingRecent = value;
    update();
  }

  Future getRecentOrders({bool showLoading = true}) async {
    if (isLoadingRecent) return;
    if (showLoading) toggleLoadingRecent(true);
    List<String> typesToFetch = ["pending", "done", "canceled", "approved", "waiting_approval"];
    if (roleText == "customer") typesToFetch.addAll(["available", "draft"]);
    List<OrderModel2> newProcessingOrders =
        await RemoteServices.fetchMyOrders(types: ["processing"], role: roleText) ?? [];
    List<OrderModel2> newOrders = await RemoteServices.fetchMyOrders(types: typesToFetch, role: roleText) ?? [];
    recentOrders.addAll(newProcessingOrders);
    recentOrders.addAll(newOrders);
    if (newProcessingOrders.isNotEmpty) currOrders.addAll(newProcessingOrders);
    //currentOrder = newOrders.first;
    if (showLoading) toggleLoadingRecent(false);
  }

  Future<void> refreshRecentOrders({bool showLoading = true}) async {
    currOrders.clear();
    recentOrders.clear();
    await getRecentOrders(showLoading: showLoading);
  }

  //-------------------------------- explore -----------------------------

  List<GovernorateModel> governorates = [];
  GovernorateModel? selectedGovernorate;

  List<OrderModel2> exploreOrders = [];

  bool _isLoadingExplore = false;
  bool get isLoadingExplore => _isLoadingExplore;
  void toggleLoadingExplore(bool value) {
    _isLoadingExplore = value;
    update();
  }

  bool _isLoadingGovernorates = false;
  bool get isLoadingGovernorates => _isLoadingGovernorates;
  void toggleLoadingGovernorate(bool value) {
    _isLoadingGovernorates = value;
    update();
  }

  void setGovernorate(GovernorateModel? governorate) {
    selectedGovernorate = governorate;
    refreshExploreOrders();
  }

  void getGovernorates() async {
    if (isLoadingGovernorates) return;
    toggleLoadingGovernorate(true);
    List<GovernorateModel> newItems = await RemoteServices.fetchGovernorates() ?? [];
    governorates.addAll(newItems);
    if (newItems.isNotEmpty) setGovernorate(governorates[0]);
    toggleLoadingGovernorate(false);
  }

  Future getExploreOrders({bool showLoading = true}) async {
    if (isLoadingExplore || selectedGovernorate == null) return;
    if (showLoading) toggleLoadingExplore(true);
    List<OrderModel2> newItems = await RemoteServices.fetchExploreOrders(
          role: roleText,
          governorateID: selectedGovernorate!.id,
          page: 1, //todo:pagination
          searchQuery: searchQueryMyOrders.text.trim(),
          minPrice: filterController.minPrice == filterController.sliderMinPrice ? null : filterController.minPrice,
          maxPrice: filterController.maxPrice == filterController.sliderMaxPrice ? null : filterController.maxPrice,
          vehicleType: filterController.selectedVehicleType?.id,
          governorate: null,
          currency: filterController.selectedCurrency?.id,
        ) ??
        [];
    exploreOrders.addAll(newItems);
    if (showLoading) toggleLoadingExplore(false);
  }

  Future<void> refreshExploreOrders({bool showLoading = true}) async {
    exploreOrders.clear();
    await getExploreOrders(showLoading: showLoading);
  }

  Future refreshEverything() async {
    await refreshOrders(showLoading: false);
    await refreshRecentOrders(showLoading: false);
    if (roleText != "customer") await refreshExploreOrders(showLoading: false);
    //print("update============================");
    update();
  }

  // bool _isLoadingSubmit = false;
  // bool get isLoadingSubmit => _isLoadingSubmit;
  // void toggleLoadingSubmit(bool value) {
  //   _isLoadingSubmit = value;
  //   update();
  // }
  //
  // Position? position;
}
