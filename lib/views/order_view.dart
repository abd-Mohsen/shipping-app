import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/order_controller.dart';
import 'package:shipment/models/employee_model.dart';
import 'package:shipment/models/order_model.dart';
import 'package:shipment/models/vehicle_model.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/mini_order_card.dart';
import 'package:shipment/views/edit_order_view.dart';

import 'components/auth_field.dart';
import 'components/input_field.dart';

class OrderView extends StatelessWidget {
  //todo: make it different depending on status, and on wither if the user is driver or customer
  //todo: improve (use primary containers)
  //todo: edit and delete (hide if not draft or available (ask) )
  //todo: add payment methods, driver details and status
  //todo: show vehicle type and plate
  final OrderModel order;
  final bool isCustomer;
  const OrderView({
    super.key,
    required this.order,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    GetStorage getStorage = GetStorage();
    bool isCompany = getStorage.read("role") == "company";
    bool isEmployee = getStorage.read("role") == "company_employee";
    late CustomerHomeController cHC;
    late DriverHomeController dHC;
    late CompanyHomeController cHC2;
    isCustomer
        ? cHC = Get.find()
        : isCompany
            ? cHC2 = Get.find()
            : dHC = Get.find();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'view order'.tr.toUpperCase(),
          style: tt.titleMedium!.copyWith(color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          if (isCustomer && ["draft", "available"].contains(order.status))
            IconButton(
              onPressed: () {
                Get.to(() => EditOrderView(order: order));
              },
              icon: order.dateTime.isBefore(DateTime.now()) ? Badge(child: Icon(Icons.edit)) : Icon(Icons.edit),
            ),
          if (isCustomer && ["draft", "available"].contains(order.status))
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "",
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "delete the order?".tr,
                      style: tt.titleLarge!.copyWith(color: cs.onSurface),
                    ),
                  ),
                  confirm: TextButton(
                    onPressed: () {
                      Get.back();
                      cHC.deleteOrder(order.id);
                    },
                    child: Text(
                      "yes".tr,
                      style: tt.titleMedium!.copyWith(color: Colors.red),
                    ),
                  ),
                  cancel: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "no".tr,
                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.delete),
            )
        ],
      ),
      body: GetBuilder<OrderController>(
        init: isCustomer
            ? OrderController(order: order, customerHomeController: cHC)
            : isCompany
                ? OrderController(order: order, companyHomeController: cHC2)
                : OrderController(order: order, driverHomeController: dHC),
        builder: (controller) {
          return Column(
            children: [
              // todo (make the notification enter to this page)
              // todo make a button to start the trip
              // todo show driver and customer info after accepting
              if (isCustomer && order.status == "pending" && !order.ownerApproved)
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(
                        color: cs.onSurface,
                      ),
                    ),
                    title: Center(
                      child: Text(
                        "${order.driver!.name} ${"wants to take this order".tr}",
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "",
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "accept the order?".tr,
                                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                                confirm: TextButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.confirmOrderCustomer();
                                  },
                                  child: Text(
                                    "yes".tr,
                                    style: tt.titleMedium!.copyWith(color: Colors.red),
                                  ),
                                ),
                                cancel: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "no".tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.green.shade500),
                            ),
                            child: !controller.isLoadingSubmit
                                ? Text(
                                    "accept".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  )
                                : SpinKitThreeBounce(
                                    color: cs.onPrimary,
                                    size: 18,
                                  ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "",
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "refuse the order?".tr,
                                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                                confirm: TextButton(
                                  onPressed: () {
                                    Get.back();
                                    //refuse with loading
                                    //todo: don't let user click either buttons if one is loading
                                  },
                                  child: Text(
                                    "yes".tr,
                                    style: tt.titleMedium!.copyWith(color: Colors.red),
                                  ),
                                ),
                                cancel: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "no".tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent),
                            ),
                            child: true
                                ? Text(
                                    "refuse".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  )
                                : SpinKitThreeBounce(
                                    color: cs.onPrimary,
                                    size: 18,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!isCustomer && order.status == "pending" && order.ownerApproved && !order.driverApproved)
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: BorderSide(
                        color: cs.onSurface,
                        width: 1.5,
                      ),
                    ),
                    title: Center(
                      child: Text(
                        "${order.orderOwner.name} ${"accepted your request".tr}",
                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.bottomSheet(
                                GetBuilder<OrderController>(
                                  builder: (controller) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                        color: cs.surface,
                                      ),
                                      //height: MediaQuery.of(context).size.height / 1.5,
                                      child: Form(
                                        key: controller.formKey,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Text(
                                                "select payment method".tr,
                                                style: tt.titleMedium!
                                                    .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              child: Scrollbar(
                                                child: ListView.builder(
                                                  itemCount: order.paymentMethods.length,
                                                  itemBuilder: (context, i) => RadioListTile(
                                                    title: Text(
                                                      order.paymentMethods[i].payment.methodName,
                                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                    ),
                                                    value: order.paymentMethods[i],
                                                    groupValue: controller.selectedPayment,
                                                    onChanged: (v) {
                                                      controller.selectPayment(v!);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: ["bank_account", "money_transfer"]
                                                  .contains(controller.selectedPayment.payment.methodName),
                                              child: InputField(
                                                controller: controller.fullName,
                                                label: "full name".tr,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.next,
                                                prefixIcon: Icons.person,
                                                validator: (val) {
                                                  if (!["bank_account", "money_transfer"]
                                                      .contains(controller.selectedPayment.payment.methodName))
                                                    return null;
                                                  return validateInput(controller.fullName.text, 0, 100, "");
                                                },
                                                onChanged: (val) {
                                                  if (controller.buttonPressed)
                                                    controller.formKey.currentState!.validate();
                                                },
                                              ),
                                            ),
                                            Visibility(
                                              visible: ["bank_account"]
                                                  .contains(controller.selectedPayment.payment.methodName),
                                              child: InputField(
                                                controller: controller.accountDetails,
                                                label: "account details".tr,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.next,
                                                prefixIcon: Icons.short_text_outlined,
                                                validator: (val) {
                                                  if (!["bank_account"]
                                                      .contains(controller.selectedPayment.payment.methodName))
                                                    return null;
                                                  return validateInput(controller.accountDetails.text, 0, 100, "");
                                                },
                                                onChanged: (val) {
                                                  if (controller.buttonPressed)
                                                    controller.formKey.currentState!.validate();
                                                },
                                              ),
                                            ),
                                            Visibility(
                                              visible: ["money_transfer"]
                                                  .contains(controller.selectedPayment.payment.methodName),
                                              child: InputField(
                                                //todo: recommend old phone numbers
                                                controller: controller.phoneNumber,
                                                label: "phone number".tr,
                                                keyboardType: TextInputType.number,
                                                textInputAction: TextInputAction.next,
                                                prefixIcon: Icons.phone_android,
                                                validator: (val) {
                                                  if (!["money_transfer"]
                                                      .contains(controller.selectedPayment.payment.methodName))
                                                    return null;
                                                  return validateInput(controller.phoneNumber.text, 4, 15, "",
                                                      wholeNumber: true);
                                                },
                                                onChanged: (val) {
                                                  if (controller.buttonPressed)
                                                    controller.formKey.currentState!.validate();
                                                },
                                              ),
                                            ),
                                            CustomButton(
                                              onTap: () {
                                                isCompany
                                                    ? controller.confirmOrderCompany()
                                                    : controller.confirmOrderDriver();
                                              },
                                              child: Center(
                                                child: controller.isLoadingSubmit
                                                    ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                                    : Text(
                                                        "add".tr.toUpperCase(),
                                                        style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.green.shade500),
                            ),
                            child: !controller.isLoadingSubmit
                                ? Text(
                                    "confirm".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  )
                                : SpinKitThreeBounce(
                                    color: cs.onPrimary,
                                    size: 18,
                                  ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "",
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "cancel the request?".tr,
                                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                                confirm: TextButton(
                                  onPressed: () {
                                    Get.back();
                                    //refuse with loading
                                    //todo: don't let user click either buttons if one is loading
                                  },
                                  child: Text(
                                    "yes".tr,
                                    style: tt.titleMedium!.copyWith(color: Colors.red),
                                  ),
                                ),
                                cancel: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "no".tr,
                                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent),
                            ),
                            child: true
                                ? Text(
                                    "cancel".tr,
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  )
                                : SpinKitThreeBounce(
                                    color: cs.onPrimary,
                                    size: 18,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (isCustomer && controller.isTracking)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: OSMFlutter(
                        controller: controller.mapController,
                        mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                        osmOption: OSMOption(
                          isPicker: false,
                          userLocationMarker: UserLocationMaker(
                            personMarker: MarkerIcon(
                              icon: Icon(Icons.person, color: cs.primary, size: 40),
                            ),
                            directionArrowMarker: MarkerIcon(
                              icon: Icon(Icons.location_history, color: cs.primary, size: 40),
                            ),
                          ),
                          zoomOption: const ZoomOption(
                            initZoom: 17.65,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  children: [
                    if (!isCustomer && order.status == "available")
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: CustomButton(
                          onTap: () {
                            if (isCompany || isEmployee) {
                              Get.bottomSheet(
                                GetBuilder<OrderController>(
                                  builder: (controller) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                        color: cs.surface,
                                      ),
                                      height: MediaQuery.of(context).size.height / 3,
                                      child: Form(
                                        key: controller.formKey,
                                        child: ListView(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Text(
                                                "select vehicle and driver",
                                                style: tt.titleMedium!
                                                    .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              child: controller.isLoadingVehicles
                                                  ? SpinKitThreeBounce(color: cs.primary, size: 20)
                                                  : Column(
                                                      children: [
                                                        DropdownSearch<VehicleModel>(
                                                          validator: (type) {
                                                            if (type == null) return "you must select vehicle".tr;
                                                            return null;
                                                          },
                                                          compareFn: (type1, type2) => type1.id == type2.id,
                                                          popupProps: PopupProps.menu(
                                                            showSearchBox: false,
                                                            menuProps: MenuProps(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                            ),
                                                            searchFieldProps: TextFieldProps(
                                                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                              decoration: InputDecoration(
                                                                fillColor: Colors.white70,
                                                                hintText: "vehicle".tr,
                                                                prefix: Padding(
                                                                  padding: const EdgeInsets.all(4),
                                                                  child: Icon(Icons.search, color: cs.onSurface),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          decoratorProps: DropDownDecoratorProps(
                                                            baseStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                            decoration: InputDecoration(
                                                              prefixIcon: const Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                                                child: Icon(Icons.local_shipping),
                                                              ),
                                                              labelText: "required vehicle".tr,
                                                              labelStyle: tt.titleSmall!
                                                                  .copyWith(color: cs.onSurface.withOpacity(0.7)),
                                                              floatingLabelBehavior: FloatingLabelBehavior.never,
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(32),
                                                                borderSide: BorderSide(
                                                                  width: .5,
                                                                  color: cs.onSurface,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(32),
                                                                borderSide: BorderSide(
                                                                  width: 0.5,
                                                                  color: cs.onSurface,
                                                                ),
                                                              ),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(32),
                                                                borderSide: BorderSide(
                                                                  width: 0.5,
                                                                  color: cs.error,
                                                                ),
                                                              ),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(32),
                                                                borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: cs.error,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          items: (filter, infiniteScrollProps) =>
                                                              controller.availableVehicles,
                                                          itemAsString: (VehicleModel v) => v.licensePlate,
                                                          onChanged: (VehicleModel? v) async {
                                                            controller.selectVehicle(v);
                                                            await Future.delayed(const Duration(milliseconds: 1000));
                                                            if (controller.buttonPressed) {
                                                              controller.formKey.currentState!.validate();
                                                            }
                                                          },
                                                          //enabled: !con.enabled,
                                                        ),
                                                        const SizedBox(height: 12),
                                                        if (isCompany)
                                                          DropdownSearch<EmployeeModel>(
                                                            validator: (type) {
                                                              if (type == null) return "you must select an employee".tr;
                                                              return null;
                                                            },
                                                            compareFn: (type1, type2) => type1.id == type2.id,
                                                            popupProps: PopupProps.menu(
                                                              showSearchBox: false,
                                                              menuProps: MenuProps(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                              ),
                                                              searchFieldProps: TextFieldProps(
                                                                style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                                decoration: InputDecoration(
                                                                  fillColor: Colors.white70,
                                                                  hintText: "employee".tr,
                                                                  prefix: Padding(
                                                                    padding: const EdgeInsets.all(4),
                                                                    child: Icon(Icons.search, color: cs.onSurface),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            decoratorProps: DropDownDecoratorProps(
                                                              baseStyle: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                              decoration: InputDecoration(
                                                                prefixIcon: const Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                                                                  child: Icon(Icons.person),
                                                                ),
                                                                labelText: "required employee".tr,
                                                                labelStyle: tt.titleSmall!
                                                                    .copyWith(color: cs.onSurface.withOpacity(0.7)),
                                                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(32),
                                                                  borderSide: BorderSide(
                                                                    width: .5,
                                                                    color: cs.onSurface,
                                                                  ),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(32),
                                                                  borderSide: BorderSide(
                                                                    width: 0.5,
                                                                    color: cs.onSurface,
                                                                  ),
                                                                ),
                                                                errorBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(32),
                                                                  borderSide: BorderSide(
                                                                    width: 0.5,
                                                                    color: cs.error,
                                                                  ),
                                                                ),
                                                                focusedErrorBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(32),
                                                                  borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: cs.error,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            items: (filter, infiniteScrollProps) =>
                                                                controller.availableEmployees,
                                                            itemAsString: (EmployeeModel e) =>
                                                                "${e.user.firstName} ${e.user.lastName}",
                                                            onChanged: (EmployeeModel? e) async {
                                                              controller.selectEmployee(e);
                                                              await Future.delayed(const Duration(milliseconds: 1000));
                                                              if (controller.buttonPressed) {
                                                                controller.formKey.currentState!.validate();
                                                              }
                                                            },
                                                            //enabled: !con.enabled,
                                                          ),
                                                      ],
                                                    ),
                                            ),
                                            CustomButton(
                                              onTap: () {
                                                controller.acceptOrderCompany();
                                              },
                                              child: Center(
                                                child: controller.isLoadingSubmit
                                                    ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                                    : Text(
                                                        "add".tr.toUpperCase(),
                                                        style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              controller.getCurrOrders();
                              showDialog(
                                context: context,
                                builder: (context) => GetBuilder<OrderController>(builder: (controller) {
                                  return AlertDialog(
                                    title: Text(
                                      "accept the order?".tr,
                                      style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                    ),
                                    content: controller.isLoadingCurr
                                        ? SpinKitSquareCircle(color: cs.primary, size: 26)
                                        : controller.currOrders.isEmpty
                                            ? null
                                            : Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: SizedBox(
                                                  height: MediaQuery.of(context).size.height / 2,
                                                  width: MediaQuery.of(context).size.width / 1.5,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "you currently have these orders".tr,
                                                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount: controller.currOrders.length,
                                                          itemBuilder: (context, i) => MiniOrderCard(
                                                            order: controller.currOrders[i],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                          controller.acceptOrderDriver();
                                        },
                                        child: Text(
                                          "yes".tr,
                                          style: tt.titleMedium!.copyWith(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          "no".tr,
                                          style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            }
                          },
                          child: Center(
                            child: controller.isLoadingSubmit
                                ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                : Text(
                                    "apply".tr.toUpperCase(),
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  ),
                          ),
                        ),
                      ),
                    //todo: show the name of the driver ("driver" didnt start the order yet)
                    if (!isCustomer && !isCompany && order.status == "approved" && order.driverApproved)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: CustomButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => GetBuilder<OrderController>(builder: (controller) {
                                return AlertDialog(
                                  title: Text(
                                    "begin the order?".tr,
                                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "customer will track driver's progress".tr,
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.beginOrderDriver();
                                      },
                                      child: Text(
                                        "yes".tr,
                                        style: tt.titleMedium!.copyWith(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        "no".tr,
                                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                          child: Center(
                            child: controller.isLoadingSubmit
                                ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                : Text(
                                    "begin".tr.toUpperCase(),
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  ),
                          ),
                        ),
                      ),
                    if (!isCustomer && order.status == "processing")
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: CustomButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => GetBuilder<OrderController>(builder: (controller) {
                                return AlertDialog(
                                  title: Text(
                                    "finish the order?".tr,
                                    style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                  ),
                                  content: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "press yes if you reached your destination".tr,
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.finishOrderDriver();
                                      },
                                      child: Text(
                                        "yes".tr,
                                        style: tt.titleMedium!.copyWith(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        "no".tr,
                                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                          child: Center(
                            child: controller.isLoadingSubmit
                                ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                : Text(
                                    "finish".tr.toUpperCase(),
                                    style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                  ),
                          ),
                        ),
                      ),
                    if (isCustomer || (order.status != "available"))
                      EasyStepper(
                        activeStep: controller.statusIndex,
                        activeStepTextColor: cs.primary,
                        finishedStepTextColor: cs.onSurface,
                        unreachedStepTextColor: cs.onSurface.withOpacity(0.7),
                        internalPadding: 8,
                        showLoadingAnimation: false,
                        stepRadius: 8,
                        showStepBorder: false,
                        steps: List.generate(
                          controller.statuses.length,
                          (i) => EasyStep(
                            customStep: CircleAvatar(
                              radius: 8,
                              backgroundColor: cs.primary,
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: controller.statusIndex >= i ? cs.primary : Colors.white,
                              ),
                            ),
                            title: controller.statuses[i].tr,
                            topTitle: i % 2 == 0,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        order.price + " " + "SYP",
                        style: tt.headlineMedium!.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        order.description,
                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: cs.onSurface,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            order.orderLocation.name,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: cs.onSurface,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            Jiffy.parseFromDateTime(order.dateTime).format(pattern: "d / M / y") +
                                "    " +
                                Jiffy.parseFromDateTime(order.dateTime).jm,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.watch_later_outlined,
                    //         color: cs.onSurface,
                    //         size: 22,
                    //       ),
                    //       const SizedBox(width: 16),
                    //       Text(
                    //         Jiffy.parseFromDateTime(order.dateTime).jm,
                    //         style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    if (!isCustomer)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: cs.onSurface,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              order.orderOwner.name,
                              style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(
                        thickness: 2,
                        color: cs.primary,
                        indent: 80,
                        endIndent: 80,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: cs.secondaryContainer,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: cs.primary),
                                const SizedBox(width: 8),
                                Text(
                                  "address".tr,
                                  style: tt.titleLarge!.copyWith(color: cs.onSecondaryContainer),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      "from".tr,
                                      style: tt.titleSmall!
                                          .copyWith(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      order.startPoint.toString(),
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      "to".tr,
                                      style: tt.titleSmall!
                                          .copyWith(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      order.endPoint.toString(),
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isCustomer && order.driver!.name.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Card(
                          color: cs.secondaryContainer,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, color: cs.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      "driver info".tr,
                                      style: tt.titleLarge!.copyWith(color: cs.onSecondaryContainer),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      order.driver!.name,
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      order.driver!.phoneNumber.toString(),
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (!isCustomer && order.status != "available")
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Card(
                          color: cs.secondaryContainer,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, color: cs.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      "owner info".tr,
                                      style: tt.titleLarge!.copyWith(color: cs.onSecondaryContainer),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      order.orderOwner.name,
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: Text(
                                      order.orderOwner.phoneNumber.toString(),
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Card(
                      color: cs.secondaryContainer,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.text_snippet, color: cs.primary),
                                const SizedBox(width: 8),
                                Text(
                                  "details".tr,
                                  style: tt.titleLarge!.copyWith(color: cs.onSecondaryContainer),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (order.otherInfo != null)
                              Text(
                                order.otherInfo!,
                                style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1000,
                              ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    "${"weight".tr}: ",
                                    style: tt.titleSmall!.copyWith(
                                      color: cs.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.8,
                                    child: Text(
                                      order.weight,
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (order.withCover)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 1.8,
                                      child: Text(
                                        "covered vehicle is required".tr,
                                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    "${"added at".tr}: ",
                                    style: tt.titleSmall!.copyWith(
                                      color: cs.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      Jiffy.parseFromDateTime(order.createdAt).format(pattern: "d / M / y"),
                                      style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
