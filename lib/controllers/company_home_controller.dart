import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shipment/controllers/my_vehicles_controller.dart';
import 'package:shipment/models/company_stats_model.dart';
import 'package:shipment/models/employee_model.dart';
import '../models/governorate_model.dart';
import '../models/order_model_2.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'filter_controller.dart';
import 'home_navigation_controller.dart';
import 'login_controller.dart';
import 'package:flutter/material.dart';

import 'otp_controller.dart';

class CompanyHomeController extends GetxController {
  HomeNavigationController homeNavigationController;
  FilterController filterController;
  MyVehiclesController myVehiclesController;
  CompanyHomeController({
    required this.homeNavigationController,
    required this.filterController,
    required this.myVehiclesController,
  });

  @override
  onInit() {
    getCurrentUser();
    getMyEmployees();
    getGovernorates();
    getCompanyStats();
    getRecentOrders();
    getOrders();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

  TextEditingController searchQueryMyOrders = TextEditingController();
  TextEditingController searchQueryExploreOrders = TextEditingController();

  Timer? _debounce;
  search({required bool explore}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      explore ? refreshExploreOrders() : refreshOrders();
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;
  void toggleLoadingUser(bool value) {
    _isLoadingUser = value;
    update();
  }

  bool _isLoadingSubmit = false;
  bool get isLoadingSubmit => _isLoadingSubmit;
  void toggleLoadingSubmit(bool value) {
    _isLoadingSubmit = value;
    update();
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void getCurrentUser({bool refresh = false}) async {
    if (isLoadingUser) return;
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    if (!refresh && _currentUser != null) {
      // if (_currentUser!.idStatus.toLowerCase() != "verified") {
      //   CompleteAccountController cAC = Get.put(CompleteAccountController(homeController: this));
      //   Get.to(const CompleteAccountView());
      // }
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }
    }

    if (currentUser == null) {
      await Future.delayed(Duration(seconds: 10));
      getCurrentUser();
    }

    toggleLoadingUser(false);
  }

  void logout() async {
    if (currentUser != null && await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
  }

  //-------------------------------------------------
  List<OrderModel2> myOrders = [];

  List<OrderModel2> recentOrders = [];

  List<String> orderTypes = ["taken", "accepted", "current", "finished"];

  List<IconData> orderIcons = [
    Icons.watch_later,
    Icons.done,
    Icons.local_shipping,
    Icons.done_all,
  ];

  List<String> selectedOrderTypes = ["current"];
  //String selectedOrderType = "current";

  OrderModel2? currentOrder;

  void setOrderType(String? type, bool clear, {bool selectAll = false}) {
    if (type == null) return;
    if (clear) {
      selectedOrderTypes.clear();
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

  Future getOrders({bool showLoading = true}) async {
    if (isLoading) return;
    if (showLoading) toggleLoading(true);
    List<String> typesToFetch = [];
    if (selectedOrderTypes.contains("accepted")) typesToFetch.addAll(["approved"]);
    if (selectedOrderTypes.contains("taken")) typesToFetch.addAll(["pending", "waiting_approval"]);
    if (selectedOrderTypes.contains("current")) typesToFetch.addAll(["processing"]);
    if (selectedOrderTypes.contains("finished")) typesToFetch.addAll(["done", "canceled"]);
    List<OrderModel2> newItems = await RemoteServices.fetchCompanyOrders(
          types: typesToFetch,
          page: 1, //todo:pagination
          searchQuery: searchQueryMyOrders.text.trim(),
          minPrice: filterController.minPrice == filterController.sliderMinPrice ? null : filterController.minPrice,
          maxPrice: filterController.maxPrice == filterController.sliderMaxPrice ? null : filterController.maxPrice,
          vehicleType: filterController.selectedVehicleType?.id,
          governorate: filterController.selectedGovernorate?.id,
          currency: filterController.selectedCurrency?.id,
        ) ??
        [];
    myOrders.addAll(newItems);
    if (showLoading) toggleLoading(false);
  }

  Future<void> refreshOrders({bool showLoading = true}) async {
    myOrders.clear();
    await getOrders(showLoading: showLoading);
  }

  bool isLoadingRecent = false;
  void toggleLoadingRecent(bool value) {
    isLoadingRecent = value;
    update();
  }

  Future getRecentOrders({bool showLoading = true}) async {
    if (isLoadingRecent) return;
    if (showLoading) toggleLoadingRecent(true);
    List<String> typesToFetch = ["pending", "done", "canceled", "approved", "waiting_approval"];
    List<OrderModel2> newProcessingOrders = await RemoteServices.fetchCompanyOrders(types: ["processing"]) ?? [];
    List<OrderModel2> newOrders = await RemoteServices.fetchCompanyOrders(types: typesToFetch) ?? [];
    recentOrders.addAll(newProcessingOrders);
    recentOrders.addAll(newOrders);
    if (newProcessingOrders.isNotEmpty) currentOrder = newProcessingOrders.first;
    //currentOrder = newOrders.first;
    if (showLoading) toggleLoadingRecent(false);
  }

  Future<void> refreshRecentOrders({bool showLoading = true}) async {
    currentOrder = null;
    recentOrders.clear();
    await getRecentOrders(showLoading: showLoading);
  }

  Future refreshEverything() async {
    await refreshOrders(showLoading: false);
    await refreshRecentOrders(showLoading: false);
    print("update============================");
    update();
  }

  // -----------------employees-----------------------

  bool _isLoadingEmployees = false;
  bool get isLoadingEmployees => _isLoadingEmployees;
  void toggleLoadingEmployees(bool value) {
    _isLoadingEmployees = value;
    update();
  }

  bool _isLoadingEmployeesAdd = false;
  bool get isLoadingEmployeesAdd => _isLoadingEmployeesAdd;
  void toggleLoadingEmployeesAdd(bool value) {
    _isLoadingEmployeesAdd = value;
    update();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> addEmployeeFormKey = GlobalKey<FormState>();
  bool employeeButtonPressed = false;

  TextEditingController phone = TextEditingController();

  void addEmployee() async {
    if (isLoadingEmployeesAdd) return;
    bool valid = addEmployeeFormKey.currentState!.validate();
    if (!valid) return;
    employeeButtonPressed = true;
    toggleLoadingEmployeesAdd(true);
    bool success = await RemoteServices.addEmployee(phone.text);
    if (success) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "an invitation code was send to the employee".tr,
        duration: const Duration(milliseconds: 4500),
      ));
      phone.text == "";
    }
    toggleLoadingEmployeesAdd(false);
  }

  final List myEmployees = [];

  void getMyEmployees() async {
    if (isLoadingEmployees) return;
    toggleLoadingEmployees(true);
    List<EmployeeModel> newItems = await RemoteServices.fetchMyEmployees() ?? [];
    myEmployees.addAll(newItems);
    toggleLoadingEmployees(false);
  }

  Future<void> refreshMyEmployees() async {
    myEmployees.clear();
    getMyEmployees();
  }

  void deleteEmployee(int id) async {
    bool res = await RemoteServices.deleteEmployee(id);
    if (res) {
      myEmployees.removeWhere((employee) => employee.id == id);
      update();
    }
  }

  //------------------bottom bar-----------------------

  // int tabIndex = 1;
  // bool canNavigate = true;
  //
  // void changeTab(int i) {
  //   if (!canNavigate) {
  //     //show msg: you must have an accepted car in order to use the app
  //     return;
  //   }
  //   tabIndex = i;
  //   update();
  // }

  //---------------------------------------explore orders-------------------------

  List<GovernorateModel> governorates = [];
  GovernorateModel? selectedGovernorate;

  List<OrderModel2> exploreOrders = [];
  List<OrderModel2> currOrders = [];
  List<OrderModel2> historyOrders = [];

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

  Future<void> refreshExploreOrders() async {
    exploreOrders.clear();
    getExploreOrders();
  }

  void getGovernorates() async {
    if (isLoadingGovernorates) return;
    toggleLoadingGovernorate(true);
    List<GovernorateModel> newItems = await RemoteServices.fetchGovernorates() ?? [];
    governorates.addAll(newItems);
    if (newItems.isNotEmpty) setGovernorate(governorates[0]);
    toggleLoadingGovernorate(false);
  }

  void getExploreOrders() async {
    if (isLoadingExplore || selectedGovernorate == null) return;
    toggleLoadingExplore(true);
    List<OrderModel2> newItems = await RemoteServices.fetchCompanyOrders(
          governorateID: selectedGovernorate!.id, types: ["available", "waiting_approval"],
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
    toggleLoadingExplore(false);
  }

  //--------------------------------------------stats-------------------------------------
  bool _isLoadingStats = false;
  bool get isLoadingStats => _isLoadingStats;
  void toggleLoadingStats(bool value) {
    _isLoadingStats = value;
    update();
  }

  CompanyStatsModel? companyStats;

  Future<void> getCompanyStats() async {
    if (isLoadingStats) return;
    toggleLoadingStats(true);
    companyStats = await RemoteServices.fetchCompanyStats();
    //todo(later): filter
    toggleLoadingStats(false);
  }

  TextEditingController fileName = TextEditingController();
  GlobalKey<FormState> exportFileFormKey = GlobalKey<FormState>();

  Future<void> export() async {
    bool isValid = exportFileFormKey.currentState!.validate();
    if (!isValid) return;
    if (companyStats == null) return;

    // checking permission
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.storage.request();
      if (!newStatus.isGranted) {
        Get.showSnackbar(const GetSnackBar(
          message: "تم رفض اذن التخزين, لا يمكن تصدير الملف",
          duration: Duration(milliseconds: 1500),
        ));
        return;
      }
    }

    // setting up the excel file
    var excel = Excel.createExcel();
    Sheet sheet = excel['تقرير'];
    excel.setDefaultSheet('تقرير');
    excel.delete('Sheet1');
    sheet.isRTL = true;

    // extracting date and time
    String date = "${Jiffy.parseFromDateTime(DateTime.now()).format(pattern: "d/M/y")}";
    String time = "${Jiffy.parseFromDateTime(DateTime.now()).jm}";

    // adding metadata to the beginning of the sheet
    sheet.appendRow(
      [
        TextCellValue('اسم الشركة'),
        TextCellValue(companyStats!.companyName),
      ],
    );
    sheet.appendRow(
      [
        TextCellValue('تاريخ'),
        TextCellValue(date),
      ],
    );
    sheet.appendRow(
      [
        TextCellValue('الساعة'),
        TextCellValue(time),
      ],
    );
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('')]);

    // adding last 7 days orders data
    sheet.appendRow([TextCellValue('الطلبيات المأخوذة في الاسبوع الاخير')]);
    sheet.appendRow([
      TextCellValue('التاريخ'),
      TextCellValue('اليوم'),
      TextCellValue('الطلبيات'),
    ]);
    int dayOffset = 6;
    for (MapEntry<String, dynamic> pair in companyStats!.lastWeekOrders.entries) {
      sheet.appendRow([
        TextCellValue("${Jiffy.parseFromDateTime(DateTime.now()).subtract(days: dayOffset).format(pattern: "d/M/y")}"),
        TextCellValue(pair.key),
        TextCellValue(pair.value.toString()),
      ]);
      dayOffset--;
    }
    sheet.appendRow([TextCellValue('')]);
    sheet.appendRow([TextCellValue('')]);

    // adding governorates orders data
    sheet.appendRow([TextCellValue('الطلبيات في كل محافظة')]);
    sheet.appendRow([
      TextCellValue('المحافظة'),
      TextCellValue('الطلبيات'),
    ]);
    for (OrdersPerCity city in companyStats!.ordersPerCity) {
      sheet.appendRow([
        TextCellValue(city.orderLocationName),
        TextCellValue(city.orderCount.toString()),
      ]);
    }

    // share the file
    try {
      List<int>? fileBytes = excel.save();
      final tempDir = await getTemporaryDirectory();
      String path = "${tempDir.path}/${fileName.text}.xlsx";
      File(path).writeAsBytesSync(fileBytes!);

      await Share.shareXFiles([XFile(path)]);
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
        message: "خطأ في التخزين تأكد من الاسم",
        duration: Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
      ));
      return;
    }
    Get.back();
  }

  //////////////////////////////////////

  bool isLoadingAssign = false;
  void toggleLoadingAssign(bool value) {
    isLoadingAssign = value;
    update();
  }

  bool isLoadingToggle = false;
  void toggleLoadingToggle(bool value) {
    isLoadingToggle = value;
    update();
  }

  void assignVehicle(VehicleModel? vehicle, EmployeeModel employee) async {
    if (isLoadingAssign) return;
    toggleLoadingAssign(true);

    bool success = await RemoteServices.assignVehicle(employee.driver!.id!, vehicle!.id);
    if (success) {
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
      vehicle.employee = employee.toMini();
    }
    refreshMyEmployees();
    toggleLoadingAssign(false);
  }

  // void assignVehicle(VehicleModel? vehicle, EmployeeModel employee) async {
  //
  // }

  void unAssignVehicle(EmployeeModel employee) async {
    if (isLoadingAssign || employee.vehicle == null) return;
    toggleLoadingAssign(true);
    bool success = await RemoteServices.unAssignVehicle(employee.vehicle!.id);
    if (success) {
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
      await myVehiclesController.refreshMyVehicles();
      await Future.delayed(Duration(milliseconds: 400));
      refreshMyEmployees();
    }
    toggleLoadingAssign(false);
  }

  void toggleEmployee(EmployeeModel employee, v) async {
    if (isLoadingToggle) return;
    toggleLoadingToggle(true);
    bool success = await RemoteServices.toggleEmployee(employee.id, v);
    if (success) {
      Get.showSnackbar(GetSnackBar(
        message: "done successfully".tr,
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.green,
      ));
      employee.canAcceptOrders = v;
    }
    toggleLoadingToggle(false);
  }
}
