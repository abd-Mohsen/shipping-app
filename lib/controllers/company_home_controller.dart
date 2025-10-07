import 'dart:async';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shipment/controllers/my_vehicles_controller.dart';
import 'package:shipment/models/company_stats_model.dart';
import 'package:shipment/models/employee_model.dart';
import '../models/order_model_2.dart';
import '../models/vehicle_model.dart';
import '../services/remote_services.dart';
import 'package:flutter/material.dart';

class CompanyHomeController extends GetxController {
  MyVehiclesController myVehiclesController = Get.find();

  @override
  onInit() {
    getMyEmployees();
    getCompanyStats();
    super.onInit();
  }

  TextEditingController searchQueryMyOrders = TextEditingController();
  TextEditingController searchQueryExploreOrders = TextEditingController();

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

  void addEmployee(String otpMethod) async {
    if (isLoadingEmployeesAdd) return;
    bool valid = addEmployeeFormKey.currentState!.validate();
    if (!valid) return;
    employeeButtonPressed = true;
    toggleLoadingEmployeesAdd(true);
    bool success = await RemoteServices.addEmployee(phone.text, otpMethod);
    if (success) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        message: "an invitation code was send to the employee".tr,
        duration: const Duration(milliseconds: 4500),
        backgroundColor: Colors.green,
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

  List<OrderModel2> currOrders = [];
  List<OrderModel2> historyOrders = [];

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
    String date = Jiffy.parseFromDateTime(DateTime.now()).format(pattern: "d/M/y");
    String time = Jiffy.parseFromDateTime(DateTime.now()).jm;

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
        TextCellValue(Jiffy.parseFromDateTime(DateTime.now()).subtract(days: dayOffset).format(pattern: "d/M/y")),
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
      await Future.delayed(const Duration(milliseconds: 800));
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
