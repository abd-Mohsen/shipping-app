import 'package:get/get.dart';

import '../models/currency_model.dart';
import '../models/governorate_model.dart';
import '../models/make_order_model.dart';
import '../models/vehicle_type_model.dart';
import '../services/remote_services.dart';

class FilterController extends GetxController {
  @override
  onInit() {
    geFilterInfo();
    getGovernorates();
    super.onInit();
  }

  double minPrice = 0.0;
  double maxPrice = 10.0;

  double sliderMinPrice = 0.0;
  double sliderMaxPrice = 10.0;

  void setPriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    update();
  }

  bool isLoadingInfo = false;
  void toggleLoadingInfo(bool value) {
    isLoadingInfo = value;
    update();
  }

  Future geFilterInfo() async {
    toggleLoadingInfo(true);
    MakeOrderModel? model = await RemoteServices.fetchMakeOrderInfo();
    if (model == null) {
      await Future.delayed(const Duration(seconds: 10));
      geFilterInfo();
    } else {
      vehicleTypes = model.vehicleTypes;
      currencies = model.currencies;
      selectedCurrency = currencies.first;
      resetRange();
      toggleLoadingInfo(false);
    }
  }

  List<VehicleTypeModel> vehicleTypes = [];
  List<CurrencyModel> currencies = [];

  VehicleTypeModel? selectedVehicleType;
  void selectVehicleType(VehicleTypeModel? type) {
    selectedVehicleType = type;
    update();
  }

  CurrencyModel? selectedCurrency;
  void selectCurrency(CurrencyModel? currency) {
    selectedCurrency = currency;
    if (currency != null) resetRange();
    update();
  }

  void resetRange() {
    minPrice = 0.0;
    maxPrice = 2500.0 * selectedCurrency!.exchangeRateToUsd;
    sliderMinPrice = minPrice;
    sliderMaxPrice = maxPrice;
    update();
  }

  bool _isLoadingGovernorates = false;
  bool get isLoadingGovernorates => _isLoadingGovernorates;
  void toggleLoadingGovernorate(bool value) {
    _isLoadingGovernorates = value;
    update();
  }

  List<GovernorateModel> governorates = [];
  GovernorateModel? selectedGovernorate;

  void setGovernorate(GovernorateModel? governorate) {
    selectedGovernorate = governorate;
    update();
  }

  void getGovernorates() async {
    toggleLoadingGovernorate(true);
    List<GovernorateModel> newItems = await RemoteServices.fetchGovernorates() ?? [];
    governorates.addAll(newItems);
    toggleLoadingGovernorate(false);
  }
}
