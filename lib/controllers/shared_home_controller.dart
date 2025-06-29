import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/controllers/filter_controller.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
import '../models/order_model_2.dart';
import '../services/remote_services.dart';

class SharedHomeController extends GetxController {
  HomeNavigationController homeNavigationController;
  FilterController filterController;
  SharedHomeController({required this.homeNavigationController, required this.filterController});

  @override
  onInit() {
    getOrders();
    getRecentOrders();
    setPaginationListener();
    super.onInit();
  }

  TextEditingController searchQuery = TextEditingController();

  List<OrderModel2> myOrders = [];
  List<OrderModel2> currOrders = [];

  List<OrderModel2> recentOrders = [];

  List<String> orderTypes = ["not taken", "taken", "current", "finished"];

  List<IconData> orderIcons = [
    Icons.done,
    Icons.watch_later,
    Icons.local_shipping,
    Icons.done_all,
  ];

  List<String> selectedOrderTypes = ["current"];
  //String selectedOrderType = "current";

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
  ScrollController scrollController = ScrollController();

  int page = 1, limit = 10;
  bool hasMore = true;

  void setPaginationListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        getOrders();
      }
    });
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
    List<OrderModel2>? newItems = await RemoteServices.fetchCustomerOrders(
      types: typesToFetch,
      page: page,
      searchQuery: searchQuery.text.trim(),
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

  Future getRecentOrders({bool showLoading = true}) async {
    if (isLoadingRecent) return;
    if (showLoading) toggleLoadingRecent(true);
    List<String> typesToFetch = ["available", "draft", "waiting_approval", "pending", "approved", "done", "canceled"];
    List<OrderModel2> newProcessingOrders = await RemoteServices.fetchCustomerOrders(types: ["processing"]) ?? [];
    List<OrderModel2> newOrders = await RemoteServices.fetchCustomerOrders(types: typesToFetch) ?? [];
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

  Future refreshEverything() async {
    await refreshOrders(showLoading: false);
    await refreshRecentOrders(showLoading: false);
    print("update============================");
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingRecent = false;
  bool get isLoadingRecent => _isLoadingRecent;
  void toggleLoadingRecent(bool value) {
    _isLoadingRecent = value;
    update();
  }

  bool _isLoadingSubmit = false;
  bool get isLoadingSubmit => _isLoadingSubmit;
  void toggleLoadingSubmit(bool value) {
    _isLoadingSubmit = value;
    update();
  }

  Position? position;
}
