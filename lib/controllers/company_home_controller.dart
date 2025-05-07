import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shipment/models/company_stats_model.dart';
import 'package:shipment/models/employee_model.dart';
import '../models/governorate_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/complete_account_view.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'complete_account_controller.dart';
import 'login_controller.dart';
import 'package:flutter/material.dart';

import 'otp_controller.dart';

class CompanyHomeController extends GetxController {
  @override
  onInit() {
    getCurrentUser();
    getMyEmployees();
    getGovernorates();
    getHistoryOrders();
    getCurrentOrders();
    getCompanyStats();
    super.onInit();
  }

  final GetStorage _getStorage = GetStorage();

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
    toggleLoadingUser(true);
    _currentUser = await RemoteServices.fetchCurrentUser();
    if (!refresh && _currentUser != null) {
      if (_currentUser!.idStatus.toLowerCase() != "verified") {
        CompleteAccountController cAC = Get.put(CompleteAccountController(homeController: this));
        Get.to(const CompleteAccountView());
      }
      if (!_currentUser!.isVerified) {
        Get.put(OTPController(_currentUser!.phoneNumber, "register", null));
        Get.to(() => const OTPView(source: "register"));
      }
    }

    toggleLoadingUser(false);
  }

  void logout() async {
    if (await RemoteServices.logout()) {
      _getStorage.remove("token");
      _getStorage.remove("role");
      Get.put(LoginController());
      Get.offAll(() => const LoginView());
    }
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

  int tabIndex = 1;
  bool canNavigate = true;

  void changeTab(int i) {
    if (!canNavigate) {
      //show msg: you must have an accepted car in order to use the app
      return;
    }
    tabIndex = i;
    update();
  }

  //---------------------------------------explore orders-------------------------

  List<GovernorateModel> governorates = [];
  GovernorateModel? selectedGovernorate;

  List<OrderModel> exploreOrders = [];
  List<OrderModel> currOrders = [];
  List<OrderModel> historyOrders = [];

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
    toggleLoadingGovernorate(true);
    List<GovernorateModel> newItems = await RemoteServices.fetchGovernorates() ?? [];
    governorates.addAll(newItems);
    if (newItems.isNotEmpty) setGovernorate(governorates[1]);
    toggleLoadingGovernorate(false);
  }

  void getExploreOrders() async {
    //todo: implement pagination
    if (selectedGovernorate == null) return;
    toggleLoadingExplore(true);
    List<OrderModel> newItems = await RemoteServices.fetchCompanyOrders(selectedGovernorate!.id, ["available"]) ?? [];
    exploreOrders.addAll(newItems);
    toggleLoadingExplore(false);
  }

  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;
  void toggleLoadingHistory(bool value) {
    _isLoadingHistory = value;
    update();
  }

  Future<void> refreshHistoryOrders() async {
    historyOrders.clear();
    getHistoryOrders();
  }

  void getHistoryOrders() async {
    //todo: implement pagination
    toggleLoadingHistory(true);
    List<OrderModel> newItems = await RemoteServices.fetchCompanyOrders(null, ["done"]) ?? [];
    historyOrders.addAll(newItems);
    toggleLoadingHistory(false);
  }

  bool _isLoadingCurrent = false;
  bool get isLoadingCurrent => _isLoadingCurrent;
  void toggleLoadingCurrent(bool value) {
    _isLoadingCurrent = value;
    update();
  }

  Future<void> refreshCurrOrders() async {
    currOrders.clear();
    getCurrentOrders();
  }

  void getCurrentOrders() async {
    //todo: implement pagination
    //todo: current running order must appear first (separate them)
    toggleLoadingCurrent(true);
    List<OrderModel> newItems =
        await RemoteServices.fetchCompanyOrders(null, ["processing", "pending", "approved"]) ?? [];
    currOrders.addAll(newItems);
    toggleLoadingCurrent(false);
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
    toggleLoadingStats(true);
    companyStats = await RemoteServices.fetchCompanyStats();
    //todo: filter
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
}
