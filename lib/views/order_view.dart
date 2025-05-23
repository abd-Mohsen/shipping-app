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

import 'components/auth_field.dart';
import 'components/input_field.dart';
import 'make_order_view.dart';

class OrderView extends StatelessWidget {
  //todo: show payment methods
  //todo: show vehicle type and plate
  //todo: show rate box for customer when status is done (and if not rated before)
  //todo: show to customer: the driver is offline when there is no connection to web socket
  //todo: map is not scrollable
  //todo: markers are remove when map is reloaded
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
    OrderController oC = Get.put(isCustomer
        ? OrderController(order: order, customerHomeController: cHC)
        : isCompany
            ? OrderController(order: order, companyHomeController: cHC2)
            : OrderController(order: order, driverHomeController: dHC));

    callDialog() => Get.defaultDialog(
          title: "",
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "wanna call?".tr,
              style: tt.titleLarge!.copyWith(color: cs.onSurface),
            ),
          ),
          confirm: TextButton(
            onPressed: () {
              Get.back();
              oC.callPhone(
                isCustomer ? order.driver!.phoneNumber.toString() : order.orderOwner.phoneNumber.toString(),
              );
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

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.secondaryContainer,
        title: Text(
          'view order'.tr.toUpperCase(),
          style: tt.titleMedium!.copyWith(color: cs.onSecondaryContainer),
        ),
        centerTitle: true,
        actions: [
          if (isCustomer && ["draft", "available"].contains(order.status))
            IconButton(
              onPressed: () {
                Get.to(() => MakeOrderView(edit: true, order: order));
              },
              icon: order.dateTime.isBefore(DateTime.now())
                  ? const Badge(
                      smallSize: 10,
                      backgroundColor: Color(0xff00ff00),
                      child: Icon(Icons.edit),
                    )
                  : const Icon(Icons.edit),
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
        builder: (controller) {
          return Stack(
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
              Column(
                children: [
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
                                        controller.refuseOrderCustomer();
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
                                child: !controller.isLoadingRefuse
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
                                        controller.refuseOrderDriver();
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
                                child: !controller.isLoadingRefuse
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
                  //if (isCustomer && order.status == "processing" && isTracking)

                  // : Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                  //     child: Card(
                  //       color: cs.secondaryContainer,
                  //       elevation: 2,
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             GestureDetector(
                  //               onTap: () {
                  //                 controller.refreshMap();
                  //               },
                  //               child: CircleAvatar(
                  //                 backgroundColor: cs.primary,
                  //                 foregroundColor: cs.onPrimary,
                  //                 child: Icon(Icons.refresh),
                  //                 radius: 18,
                  //               ),
                  //             ),
                  //             SizedBox(width: 12),
                  //             Expanded(
                  //               //width: MediaQuery.of(context).size.width / 1.2,
                  //               child: Text(
                  //                 "driver is probably offline, wait or refresh the map".tr,
                  //                 style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  //                 maxLines: 2,
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        if (controller.mapController != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Card(
                              color: cs.secondaryContainer,
                              elevation: 3,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                        child: Text(
                                          "location".tr,
                                          style: tt.labelMedium!
                                              .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
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
                                        child: OSMFlutter(
                                          controller: controller.mapController!,
                                          mapIsLoading: SpinKitFoldingCube(color: cs.primary),
                                          onMapIsReady: (v) {
                                            controller.setMapReady(v);
                                          },
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
                                              //initZoom: 17.65,
                                              initZoom: 6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0, right: 12, top: 4),
                                    child: CustomButton(
                                      onTap: isCustomer && order.status == "processing"
                                          ? () {
                                              //
                                            }
                                          : null,
                                      isShort: true,
                                      isGradiant: true,
                                      color: isCustomer && order.status == "processing" ? cs.primary : Colors.grey,
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
                                              "order name:".tr.toUpperCase(),
                                              style: tt.labelMedium!.copyWith(
                                                  color: cs.onSecondaryContainer.withOpacity(0.5),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              order.description.toUpperCase(),
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
                                              "expected price:".tr.toUpperCase(),
                                              style: tt.labelMedium!.copyWith(
                                                color: cs.onSecondaryContainer.withOpacity(0.5),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              order.price.toInt().toString() + " " + "SYP",
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
                                              order.startPoint.toString(),
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
                                              order.endPoint.toString(),
                                              style: tt.labelMedium!.copyWith(
                                                  color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        //
                        //if (order.status != "available")
                        Card(
                          color: cs.secondaryContainer,
                          elevation: 3,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                    child: Text(
                                      "location".tr,
                                      style: tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
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
                                      controller.statuses[i],
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
                        //
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
                                                                await Future.delayed(
                                                                    const Duration(milliseconds: 1000));
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
                                                                  if (type == null)
                                                                    return "you must select an employee".tr;
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
                                                                  baseStyle:
                                                                      tt.titleSmall!.copyWith(color: cs.onSurface),
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
                                                                  await Future.delayed(
                                                                      const Duration(milliseconds: 1000));
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
                        //todo: for company: show the name of the driver ("driver" didnt start the order yet)
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            order.price.toInt().toString() + " " + "SYP",
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
                                        child: GestureDetector(
                                          onTap: () {
                                            callDialog();
                                          },
                                          child: Text(
                                            order.driver!.phoneNumber.toString(),
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
                                        child: GestureDetector(
                                          onTap: () {
                                            callDialog();
                                          },
                                          child: Text(
                                            order.orderOwner.phoneNumber.toString(),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
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
                                if (order.extraInfo.isNotEmpty)
                                  Text(
                                    order.formatExtraInfo(),
                                    style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1000,
                                  ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
