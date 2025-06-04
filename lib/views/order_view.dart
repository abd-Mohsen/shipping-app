import 'dart:ui';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:popover/popover.dart';
import 'package:shipment/controllers/company_home_controller.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/controllers/order_controller.dart';
import 'package:shipment/models/employee_model.dart';
import 'package:shipment/models/vehicle_model.dart';
import 'package:shipment/views/components/application_card.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/employee_selector.dart';
import 'package:shipment/views/components/mini_order_card.dart';
import 'package:shipment/views/components/order_page_map.dart';
import 'package:shipment/views/components/titled_scrolling_card.dart';
import 'package:shipment/views/components/vehicle_selector.dart';
import 'package:shipment/views/tracking_view.dart';

import 'components/auth_field.dart';
import 'components/input_field.dart';
import 'make_order_view.dart';

class OrderView extends StatelessWidget {
  //todo: show payment methods
  //todo: show vehicle type and plate
  //todo: show rate box for customer when status is done (and if not rated before)
  //todo: show to customer: the driver is offline when there is no connection to web socket
  //todo: map is not scrollable
  //todo: show currency here and in order cards
  //todo: refactor this shit
  //todo: tracking page

  final int orderID;
  const OrderView({
    super.key,
    required this.orderID,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    GetStorage getStorage = GetStorage();
    bool isCompany = getStorage.read("role") == "company";
    bool isEmployee = getStorage.read("role") == "company_employee";
    bool isCustomer = getStorage.read("role") == "customer";
    late CustomerHomeController cHC;
    late DriverHomeController dHC;
    late CompanyHomeController cHC2;
    isCustomer
        ? cHC = Get.find()
        : isCompany
            ? cHC2 = Get.find()
            : dHC = Get.find();
    OrderController oC = Get.put(isCustomer
        ? OrderController(orderID: orderID, customerHomeController: cHC)
        : isCompany
            ? OrderController(orderID: orderID, companyHomeController: cHC2)
            : OrderController(orderID: orderID, driverHomeController: dHC));

    alertDialog({required onPressed, required String title, Widget? content}) => AlertDialog(
          title: Text(
            title,
            style: tt.titleMedium!.copyWith(color: cs.onSurface),
          ),
          content: content,
          actions: [
            TextButton(
              onPressed: onPressed,
              child: Text(
                "yes".tr,
                style: tt.titleSmall!.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "no".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        );

    callDialog(String phone) => alertDialog(
          onPressed: () {
            Get.back();
            oC.callPhone(
              phone,
              // isCustomer
              //     ? oC.order!.acceptedApplication!.driver.phoneNumber
              //     : oC.order!.orderOwner?.phoneNumber.toString() ?? "order owner is null",
            );
          },
          title: 'do you want to call this person?'.tr,
        );

    mainButton({required alertDialog, required bool isLoading, required String buttonText}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: CustomButton(
            //todo: make sure all is wrapped with getBuilder
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => alertDialog,
              );
            },
            child: Center(
              child: isLoading
                  ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                  : Text(
                      buttonText,
                      style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                    ),
            ),
          ),
        );

    //todo: don't let user click either buttons if one is loading
    alertStack({
      required String title,
      required onPressedGreen,
      required onPressedRed,
      required bool isLoadingGreen,
      required bool isLoadingRed,
    }) =>
        Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFC400),
            //color: cs.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 2, // Soften the shadow
                spreadRadius: 1, // Extend the shadow
                offset: Offset(1, 1), // Shadow direction (x, y)
              ),
            ],
            // gradient: const LinearGradient(
            //   colors: [
            //     Color(0xFFF1C892),
            //     Color(0xFFFFC400),
            //     //Colors.amber,
            //   ],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   stops: [0, 0.5],
            // ),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  title,
                  style: tt.titleSmall!.copyWith(color: Colors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("greeen");
                        showDialog(
                          context: context,
                          builder: (context) => alertDialog(
                            onPressed: onPressedGreen,
                            title: "accept the order?".tr,
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Color(0xff10AB43)),
                      ),
                      child: !isLoadingGreen
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
                        showDialog(
                          context: context,
                          builder: (context) => alertDialog(
                            onPressed: onPressedRed,
                            title: "refuse the order?".tr,
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent),
                      ),
                      child: !isLoadingRed
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
            ],
          ),
        );

    map() => OrderPageMap(
          mapController: oC.mapController,
          onMapIsReady: (v) {
            oC.setMapReady(true);
          },
        );

    return GetBuilder<OrderController>(builder: (controller) {
      return Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent, // Add this line
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: cs.surface, // Match your AppBar
          ),
          title: Text(
            'view order'.tr.toUpperCase(),
            style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
          ),
          centerTitle: true,
          actions: [
            if (oC.order != null && isCustomer && ["draft", "available"].contains(oC.order!.status))
              IconButton(
                onPressed: () {
                  Get.to(() => MakeOrderView(edit: true, order: oC.order));
                },
                icon: oC.order!.dateTime.isBefore(DateTime.now())
                    ? const Badge(
                        smallSize: 10,
                        backgroundColor: Color(0xff00ff00),
                        child: Icon(Icons.edit),
                      )
                    : const Icon(Icons.edit),
              ),
            if (oC.order != null && isCustomer && ["draft", "available"].contains(oC.order!.status))
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
                        cHC.deleteOrder(oC.order!.id);
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
        body: controller.isLoadingOrder
            ? SpinKitSquareCircle(color: cs.primary)
            : RefreshIndicator(
                onRefresh: controller.refreshOrder,
                child: controller.order == null
                    ? Center(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Lottie.asset("assets/animations/simple truck.json", height: 200),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Center(
                                child: Text(
                                  "no data, pull down to refresh".tr,
                                  style: tt.titleMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height / 3,
                          //   child: ShaderMask(
                          //     shaderCallback: (rect) {
                          //       return LinearGradient(
                          //         colors: [
                          //           cs.primary,
                          //           Colors.black,
                          //         ],
                          //         stops: [0.4, 1.0],
                          //       ).createShader(rect);
                          //     },
                          //     blendMode: BlendMode.multiply,
                          //     child: Image.asset(
                          //       "assets/images/background.jpg",
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),

                          /// start of the page contents
                          ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            children: [
                              ///map
                              ///
                              Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4, right: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cs.secondaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2), // Shadow color
                                        blurRadius: 2, // Soften the shadow
                                        spreadRadius: 1, // Extend the shadow
                                        offset: Offset(1, 1), // Shadow direction (x, y)
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                        child: Text(
                                          "location".tr,
                                          style: tt.labelMedium!
                                              .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                        color: cs.onSecondaryContainer.withOpacity(0.1),
                                        indent: 12,
                                        endIndent: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12, right: 12),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height / 5,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: map(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 4),
                                        child: CustomButton(
                                          onTap: () {
                                            Get.to(TrackingView(map: map()));
                                          },
                                          // isCustomer && oC.order!.status == "processing" //todo
                                          //     ? () {
                                          //         //
                                          //       }
                                          //     : null,
                                          isShort: true,
                                          isGradiant: true,
                                          color:
                                              isCustomer && oC.order!.status == "processing" ? cs.primary : Colors.grey,
                                          child: Center(
                                            child: controller.isLoadingSubmit
                                                ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                                : Text(
                                                    "live tracking".tr.toUpperCase(),
                                                    style: tt.labelMedium!
                                                        .copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: cs.onSecondaryContainer.withOpacity(0.1),
                                        thickness: 1.5,
                                        indent: 12,
                                        endIndent: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "order name".tr.toUpperCase(),
                                                  style: tt.labelMedium!.copyWith(
                                                      color: cs.onSecondaryContainer.withOpacity(0.5),
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  oC.order!.description.toUpperCase(),
                                                  style: tt.labelMedium!.copyWith(
                                                      color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "expected price".tr.toUpperCase(),
                                                  style: tt.labelMedium!.copyWith(
                                                    color: cs.onSecondaryContainer.withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  oC.order!.price.toInt().toString() + " " + "SYP",
                                                  style: tt.labelMedium!.copyWith(
                                                      color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: cs.onSecondaryContainer.withOpacity(0.1),
                                        thickness: 1.5,
                                        indent: 12,
                                        endIndent: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "starting point".tr.toUpperCase(),
                                                  style: tt.labelMedium!.copyWith(
                                                    color: cs.onSecondaryContainer.withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  oC.order!.startPoint.toString(),
                                                  style: tt.labelMedium!.copyWith(
                                                      color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "destination point".tr.toUpperCase(),
                                                  style: tt.labelMedium!.copyWith(
                                                    color: cs.onSecondaryContainer.withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  oC.order!.endPoint.toString(),
                                                  style: tt.labelMedium!.copyWith(
                                                      color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),

                              ///drivers applications
                              ///
                              if (isCustomer && controller.order!.driversApplications.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  child: SizedBox(
                                    height: 250,
                                    child: TitledScrollingCard(
                                      title: "drivers applications".tr,
                                      content: ListView.builder(
                                        //physics: NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        itemCount: controller.order!.driversApplications.length,
                                        itemBuilder: (context, i) => ApplicationCard(
                                          showButtons: controller.order!.status == "waiting_approval",
                                          application: controller.order!.driversApplications[i],
                                          onTapCall: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => callDialog(
                                                  controller.order!.driversApplications[i].driver.phoneNumber),
                                            );
                                          },
                                          onTapAccept: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => alertDialog(
                                                onPressed: () {
                                                  Get.back();
                                                  controller.confirmOrderCustomer(
                                                      controller.order!.driversApplications[i].id);
                                                },
                                                title: "accept the order?".tr,
                                              ),
                                            );
                                          },
                                          onTapRefuse: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => alertDialog(
                                                onPressed: () {
                                                  Get.back();
                                                  controller.refuseOrderCustomer();
                                                },
                                                title: "refuse the order?".tr,
                                              ),
                                            );
                                            //todo: don't let user click either buttons if one is loading
                                          },
                                          isLast: i == controller.order!.driversApplications.length - 1,
                                        ),
                                      ),
                                      isEmpty: controller.order!.driversApplications.isEmpty,
                                    ),
                                  ),
                                ),

                              /// accept order
                              ///
                              if (!isCustomer && oC.order!.status == "available")
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  child: CustomButton(
                                    onTap: () {
                                      if (isEmployee) {
                                        controller.acceptOrderCompany();
                                      } else if (isCompany) {
                                        Get.bottomSheet(
                                          GetBuilder<OrderController>(
                                            builder: (controller) {
                                              return Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                                                          style: tt.titleMedium!.copyWith(
                                                              color: cs.onSurface, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                                        child: controller.isLoadingVehicles
                                                            ? SpinKitThreeBounce(color: cs.primary, size: 20)
                                                            : Column(
                                                                children: [
                                                                  // VehicleSelector<VehicleModel>(
                                                                  //   selectedItem: controller.selectedVehicle,
                                                                  //   items: controller.availableVehicles,
                                                                  //   onChanged: (VehicleModel? v) async {
                                                                  //     controller.selectVehicle(v);
                                                                  //     await Future.delayed(
                                                                  //         const Duration(milliseconds: 1000));
                                                                  //     if (controller.buttonPressed) {
                                                                  //       controller.formKey.currentState!.validate();
                                                                  //     }
                                                                  //   },
                                                                  // ),
                                                                  //todo: fix UI in this sheet
                                                                  const SizedBox(height: 12),
                                                                  if (isCompany)
                                                                    EmployeeSelector(
                                                                      selectedItem: controller.selectedEmployee,
                                                                      items: controller.availableEmployees,
                                                                      onChanged: (EmployeeModel? e) async {
                                                                        controller.selectEmployee(e);
                                                                        await Future.delayed(
                                                                            const Duration(milliseconds: 1000));
                                                                        if (controller.buttonPressed) {
                                                                          controller.formKey.currentState!.validate();
                                                                        }
                                                                      },
                                                                    )
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
                                          builder: (context) => GetBuilder<OrderController>(
                                            builder: (controller) {
                                              return alertDialog(
                                                title: "accept the order?".tr,
                                                onPressed: () {
                                                  Get.back();
                                                  controller.acceptOrderDriver();
                                                },
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
                                                                      style:
                                                                          tt.titleSmall!.copyWith(color: cs.onSurface),
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
                                              );
                                            },
                                          ),
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
                              //todo: for company: show the name of the driver ("driver" didnt start the order yet)
                              /// start order
                              ///
                              if (!isCustomer &&
                                  !isCompany &&
                                  oC.order!.status == "approved" &&
                                  oC.order!.driverApproved)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  child: mainButton(
                                    alertDialog: alertDialog(
                                      onPressed: () {
                                        Get.back();
                                        controller.beginOrderDriver();
                                      },
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "customer will track driver's progress".tr,
                                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                        ),
                                      ),
                                      title: "begin the order?".tr,
                                    ),
                                    isLoading: controller.isLoadingSubmit,
                                    buttonText: "begin".tr.toUpperCase(),
                                  ),
                                ),

                              /// finish order button
                              ///
                              if (!isCustomer && oC.order!.status == "processing")
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  child: mainButton(
                                    alertDialog: alertDialog(
                                      onPressed: () {
                                        Get.back();
                                        controller.finishOrderDriver();
                                      },
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "press yes if you reached your destination".tr,
                                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                        ),
                                      ),
                                      title: "finish the order?".tr,
                                    ),
                                    isLoading: controller.isLoadingSubmit,
                                    buttonText: "finish".tr.toUpperCase(),
                                  ),
                                ),

                              ///stepper
                              ///
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: cs.secondaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      blurRadius: 2, // Soften the shadow
                                      spreadRadius: 1, // Extend the shadow
                                      offset: Offset(1, 1), // Shadow direction (x, y)
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                      child: Text(
                                        "order status".tr,
                                        style:
                                            tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1.5,
                                      color: cs.onSecondaryContainer.withOpacity(0.1),
                                      indent: 12,
                                      endIndent: 12,
                                    ),
                                    Stepper(
                                      controlsBuilder: (BuildContext context, ControlsDetails details) {
                                        return const SizedBox.shrink(); // Removes buttons
                                      },
                                      physics: const NeverScrollableScrollPhysics(),
                                      steps: List.generate(
                                        controller.statuses.length,
                                        (i) => Step(
                                          state: StepState.indexed, // Shows simple circle instead of interactive icon
                                          isActive: false, // Makes step appear inactive
                                          title: Text(
                                            controller.statuses[i].tr,
                                            style: tt.labelMedium!
                                                .copyWith(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                          ),
                                          content: SizedBox(
                                            width: double.infinity,
                                            height: 0,
                                          ),
                                          // subtitle: Text(
                                          //   "",
                                          //   style: tt.labelMedium!
                                          //       .copyWith(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                          // ),
                                        ),
                                      ),

                                      onStepTapped: null, // Disables tapping on steps
                                      onStepCancel: null, // Disables cancel action
                                      onStepContinue: null, // Disables continue action
                                      currentStep: 2, // Set to whatever step should appear as "current"
                                    ),
                                  ],
                                ),
                              ),
                              // EasyStepper(
                              //   activeStep: controller.statusIndex,
                              //   activeStepTextColor: cs.primary,
                              //   finishedStepTextColor: cs.onSurface,
                              //   unreachedStepTextColor: cs.onSurface.withOpacity(0.7),
                              //   internalPadding: 8,
                              //   showLoadingAnimation: false,
                              //   stepRadius: 8,
                              //   showStepBorder: false,
                              //   steps: List.generate(
                              //     controller.statuses.length,
                              //     (i) => EasyStep(
                              //       customStep: CircleAvatar(
                              //         radius: 8,
                              //         backgroundColor: cs.primary,
                              //         child: CircleAvatar(
                              //           radius: 7,
                              //           backgroundColor: controller.statusIndex >= i ? cs.primary : Colors.white,
                              //         ),
                              //       ),
                              //       title: controller.statuses[i].tr,
                              //       topTitle: i % 2 == 0,
                              //     ),
                              //   ),
                              // ),

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

                              ///
                              ///driver info
                              ///
                              if (isCustomer && oC.order!.acceptedApplication != null)
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
                                                oC.order!.acceptedApplication?.driver.name ??
                                                    "accepted application is null",
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  //callDialog();
                                                },
                                                child: Text(
                                                  oC.order!.acceptedApplication?.driver.phoneNumber.toString() ??
                                                      "accepted application is null",
                                                  style: tt.titleSmall!.copyWith(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ///customer info
                              ///
                              if (!isCustomer && oC.order!.status != "available")
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
                                                oC.order!.orderOwner?.name ?? "order owner is null",
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  //callDialog();
                                                },
                                                child: Text(
                                                  oC.order!.orderOwner?.phoneNumber.toString() ?? "order owner is null",
                                                  style: tt.titleSmall!.copyWith(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ///details
                              ///
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // Shadow color
                                      blurRadius: 3, // Soften the shadow
                                      spreadRadius: 1, // Extend the shadow
                                      //offset: const Offset(2, 2), // Shadow direction (x, y)
                                    ),
                                  ],
                                  color: cs.secondaryContainer,
                                ),
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
                                    if (oC.order!.extraInfo.isNotEmpty)
                                      Text(
                                        oC.order!.formatExtraInfo(),
                                        style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1000,
                                      ),
                                    if (oC.order!.otherInfo != null)
                                      Text(
                                        oC.order!.otherInfo!,
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
                                              "${oC.order!.weight} ${oC.order!.weightUnit}",
                                              style: tt.labelMedium!.copyWith(color: cs.onSurface),
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
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${"expected arrive date".tr}: ",
                                                  style: tt.titleSmall!.copyWith(
                                                    color: cs.onSecondaryContainer,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  oC.order!.fullDate(),
                                                  style: tt.labelMedium!.copyWith(
                                                    color: oC.order!.dateTime.isBefore(DateTime.now()) &&
                                                            !["draft", "done"].contains(oC.order!.status)
                                                        ? cs.error
                                                        : cs.onSurface,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(width: 12),
                                                Visibility(
                                                  visible: oC.order!.dateTime.isBefore(DateTime.now()) &&
                                                      !["draft", "done"].contains(oC.order!.status),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showPopover(
                                                        context: context,
                                                        backgroundColor: cs.surface,
                                                        bodyBuilder: (context) => Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                                          child: Text(
                                                            "order was not accepted in time".tr,
                                                            style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Icon(Icons.info, color: cs.error, size: 18),
                                                  ),
                                                ),
                                              ],
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
                                          Expanded(
                                            child: Text(
                                              oC.order!.fullCreationDate(),
                                              style: tt.labelMedium!.copyWith(color: cs.onSurface),
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
                              const SizedBox(height: 24),
                            ],
                          ),

                          if (!isCustomer &&
                              oC.order!.status == "pending" &&
                              oC.order!.ownerApproved &&
                              !oC.order!.driverApproved)
                            Positioned(
                              top: 10,
                              left: 30,
                              right: 30,
                              child: alertStack(
                                title: "${oC.order!.orderOwner?.name ?? "order owner is null"}"
                                    " ${"accepted your request".tr}",
                                onPressedGreen: () {
                                  print("green");
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
                                                      itemCount: oC.order!.paymentMethods.length,
                                                      itemBuilder: (context, i) => RadioListTile(
                                                        title: Text(
                                                          oC.order!.paymentMethods[i].payment.methodName,
                                                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                        ),
                                                        value: oC.order!.paymentMethods[i],
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
                                onPressedRed: () {
                                  Get.back();
                                  controller.refuseOrderDriver();
                                },
                                isLoadingGreen: controller.isLoadingSubmit,
                                isLoadingRed: controller.isLoadingRefuse,
                              ),
                            ),

                          if (isCustomer && oC.order!.status == "pending" && !oC.order!.ownerApproved)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: alertStack(
                                title: "${oC.order!.acceptedApplication?.driver.name ?? ""} "
                                    "${"wants to take this order".tr}",
                                onPressedGreen: () {
                                  Get.back();
                                  //controller.confirmOrderCustomer();
                                },
                                onPressedRed: () {
                                  Get.back();
                                  controller.refuseOrderCustomer();
                                  //todo: don't let user click either buttons if one is loading
                                },
                                isLoadingGreen: controller.isLoadingSubmit,
                                isLoadingRed: controller.isLoadingRefuse,
                              ),
                            ),
                        ],
                      ),
              ),
      );
    });
  }
}
