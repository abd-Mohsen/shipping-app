//import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shipment/controllers/order_controller.dart';
import 'package:shipment/views/components/add_note_sheet.dart';
import 'package:shipment/views/components/application_card2.dart';
import 'package:shipment/models/employee_model.dart';
import 'package:shipment/views/components/application_card.dart';
import 'package:shipment/views/components/custom_button.dart';
import 'package:shipment/views/components/employee_selector.dart';
import 'package:shipment/views/components/order_page_map.dart';
import 'package:shipment/views/components/titled_card.dart';
import 'package:shipment/views/components/titled_scrolling_card.dart';
import 'package:shipment/views/tracking_view.dart';
import 'components/auth_field.dart';
import 'components/blurred_sheet.dart';
import 'components/count_down_timer.dart';
import 'components/input_field.dart';
import 'components/multi_titled_card.dart';
import 'components/sheet_details_tile.dart';
import 'make_order_view.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderView extends StatelessWidget {
  final int orderID;
  final bool? openTracking;

  const OrderView({
    super.key,
    required this.orderID,
    this.openTracking,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    GetStorage getStorage = GetStorage();
    bool isCompany = getStorage.read("role") == "company";
    bool isEmployee = getStorage.read("role") == "company_employee";
    bool isCustomer = getStorage.read("role") == "customer";
    OrderController oC = Get.put(OrderController(orderID: orderID));

    alertDialog({
      onPressed,
      required String title,
      String? cancelText,
      onPressedWhatsApp,
      Widget? content,
    }) =>
        AlertDialog(
          title: Text(
            title,
            style: tt.titleSmall!.copyWith(color: cs.onSurface),
          ),
          content: content,
          actions: [
            if (onPressed != null)
              TextButton(
                onPressed: onPressed,
                child: Text(
                  "yes".tr,
                  style: tt.titleSmall!.copyWith(color: Colors.red),
                ),
              ),
            if (onPressedWhatsApp != null)
              TextButton(
                onPressed: onPressedWhatsApp,
                child: Text(
                  "whatsapp".tr,
                  style: tt.titleSmall!.copyWith(color: Colors.green),
                ),
              ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                cancelText ?? "no".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        );

    alertDialogWithIcons({required onPressed, required String title, onPressedWhatsApp, Widget? content}) =>
        AlertDialog(
          title: Text(
            title,
            style: tt.titleMedium!.copyWith(color: cs.onSurface, fontSize: 16),
          ),
          content: content,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: onPressed,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.call, color: cs.onSurface, size: 29),
                        const SizedBox(height: 4),
                        Text(
                          "phone call".tr,
                          style: tt.labelMedium!.copyWith(color: cs.onSurface),
                        ),
                      ],
                    ),
                  ),
                  if (onPressedWhatsApp != null)
                    if (onPressedWhatsApp != null)
                      GestureDetector(
                        onTap: onPressedWhatsApp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 32),
                            const SizedBox(height: 4),
                            Text(
                              "whatsapp".tr,
                              style: tt.labelMedium!.copyWith(color: cs.onSurface),
                            ),
                          ],
                        ),
                      ),
                  // ListTile(
                  //   onTap: onPressedWhatsApp,
                  //   leading: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  //   title: Text(
                  //     "whatsapp".tr,
                  //     style: tt.titleSmall!.copyWith(color: cs.onSurface),
                  //   ),
                  // ),
                ],
              ),
            ),
            // ListTile(
            //   onTap: onPressed,
            //   leading: Icon(Icons.call, color: cs.onSurface),
            //   title: Text(
            //     "phone".tr,
            //     style: tt.titleSmall!.copyWith(color: cs.onSurface),
            //   ),
            // ),
            //const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "cancel".tr,
                style: tt.titleSmall!.copyWith(color: cs.onSurface),
              ),
            ),
          ],
        );

    callDialog(String phone) => alertDialogWithIcons(
          onPressed: () {
            Get.back();
            oC.callPhone(
              phone,
              // isCustomer
              //     ? oC.order!.acceptedApplication!.driver.phoneNumber
              //     : oC.order!.orderOwner?.phoneNumber.toString() ?? "order owner is null",
            );
          },
          onPressedWhatsApp: () {
            Get.back();
            oC.openWhatsApp(phone);
          },
          title: 'how do you want to call this person?'.tr,
        );

    //todo: dont get back if map not loaded yet (to avoid crash)
    mainButton(
            {required alertDialog, required bool isLoading, required String buttonText, Color? color, onPressed = 1}) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 12, left: 12),
          child: CustomButton(
            elevation: 2,
            onTap: () {
              if (oC.isMapReady && onPressed != null) {
                showDialog(
                  context: context,
                  builder: (context) => alertDialog,
                );
              }
            },
            color: color ?? cs.primaryContainer,
            child: Center(
              child: isLoading || !oC.isMapReady
                  ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                        ),
                        if (!isCustomer &&
                            oC.order!.status == "waiting_approval" &&
                            !oC.order!.isCancelledByMe &&
                            oC.order!.isAppliedByMe)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CountDownTimer(
                              startTime: oC.order!.driversApplications.last.appliedAt,
                              countdownDuration: const Duration(minutes: 10),
                              textStyle: tt.titleSmall!.copyWith(color: cs.onPrimary),
                              onFinished: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  oC.setCanCancel(true);
                                });
                              },
                            ),
                          )
                      ],
                    ),
            ),
          ),
        );

    alertStack({
      required String title,
      required onPressedGreen,
      required onPressedRed,
      required bool isLoadingGreen,
      required bool isLoadingRed,
      required String greenText,
      required String redText,
      bool showWarningDialogs = true,
    }) =>
        Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
          decoration: BoxDecoration(
            //color: const Color(0xFFFFC400),
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2), // Shadow color
                blurRadius: 2, // Soften the shadow
                spreadRadius: 1, // Extend the shadow
                offset: const Offset(1, 1), // Shadow direction (x, y)
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
                      onPressed: !oC.isMapReady
                          ? null
                          : !showWarningDialogs
                              ? onPressedGreen
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => alertDialog(
                                      onPressed: onPressedGreen,
                                      title: "accept the order?".tr,
                                    ),
                                  );
                                },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff10AB43)),
                      ),
                      child: isLoadingGreen || !oC.isMapReady
                          ? SpinKitThreeBounce(
                              color: cs.onPrimary,
                              size: 18,
                            )
                          : Text(
                              greenText,
                              style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                            ),
                    ),
                    ElevatedButton(
                      onPressed: !oC.isMapReady
                          ? null
                          : !showWarningDialogs
                              ? onPressedRed
                              : () {
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
                      child: isLoadingRed || !oC.isMapReady
                          ? SpinKitThreeBounce(
                              color: cs.onPrimary,
                              size: 18,
                            )
                          : Text(
                              redText,
                              style: tt.titleSmall!.copyWith(color: cs.onPrimary),
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
            if (openTracking ?? false) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // Optional: wait 1 second before navigating
                await Future.delayed(const Duration(milliseconds: 400));
                //
                // // Optional: Wait for controller to be ready
                // await Future.delayed(const Duration(milliseconds: 600));
                // // You can adjust this or use a proper "isInitialized" check
                if (Get.isRegistered<OrderController>()) {
                  // Or check for controller.isInitialized if you have that flag
                  Get.to(() => TrackingView(map: map()));
                }
              });
            }
          },
        );

    // if (openTracking ?? false) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     // Optional: wait 1 second before navigating
    //     await Future.delayed(const Duration(milliseconds: 400));
    //
    //     // Optional: Wait for controller to be ready
    //     await Future.delayed(const Duration(milliseconds: 600));
    //     // You can adjust this or use a proper "isInitialized" check
    //
    //     if (Get.isRegistered<OrderController>()) {
    //       // Or check for controller.isInitialized if you have that flag
    //       Get.to(() => TrackingView(map: map()));
    //     }
    //   });
    // }

    return GetBuilder<OrderController>(builder: (controller) {
      return PopScope(
        onPopInvokedWithResult: (bool didPop, res) {
          Get.delete<OrderController>();
        },
        child: Scaffold(
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
                      ? Badge(
                          smallSize: 10,
                          backgroundColor: cs.primaryContainer,
                          child: const Icon(Icons.edit),
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
                          style: tt.titleMedium!.copyWith(color: cs.onSurface),
                        ),
                      ),
                      confirm: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                            controller.deleteOrder();
                          },
                          child: Text(
                            "yes".tr,
                            style: tt.titleSmall!.copyWith(color: Colors.red),
                          ),
                        ),
                      ),
                      cancel: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "no".tr,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: cs.onSurface,
                  ),
                ),
              if (oC.order != null && !["draft", "available"].contains(oC.order!.status))
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: oC.order!.status == "canceled"
                        ? Color.lerp(Colors.red, Colors.white, 0.05)
                        : oC.order!.status == "done"
                            ? Color.lerp(const Color(0xff04bb2b), Colors.white, 0.15)
                            : oC.order!.status == "processing" || oC.order!.status == "draft"
                                ? cs.primaryContainer
                                : cs.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Text(
                      oC.order!.status.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelSmall!.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
            leading: IconButton(
              onPressed: () {
                Get.delete<OrderController>();
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: cs.onSurface,
              ),
            ),
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
                                //todo: there is no refuse for driver and company, i am using cancel for now
                                /// accept order
                                ///
                                if (!isCustomer &&
                                    ["available", "waiting_approval"].contains(oC.order!.status) &&
                                    !controller.order!.isAppliedByMe &&
                                    !controller.order!.isCancelledByMe)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: CustomButton(
                                      color: cs.primaryContainer,
                                      onTap: () {
                                        if (!controller.isMapReady) return;
                                        if (isCompany) {
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
                                                  //height: MediaQuery.of(context).size.height / 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(16.0),
                                                        child: Text(
                                                          "select driver".tr,
                                                          style: tt.titleMedium!.copyWith(
                                                              color: cs.onSurface, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Form(
                                                        key: controller.formKey,
                                                        child: controller.isLoadingVehicles
                                                            ? SpinKitThreeBounce(color: cs.primary, size: 20)
                                                            : Padding(
                                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                child: EmployeeSelector(
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
                                                                ),
                                                              ),
                                                      ),
                                                      CustomButton(
                                                        onTap: () {
                                                          if (!oC.isMapReady) return;
                                                          controller.acceptOrderCompany();
                                                        },
                                                        color: cs.primaryContainer,
                                                        child: Center(
                                                          child: controller.isLoadingSubmit || !oC.isMapReady
                                                              ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                                              : Text(
                                                                  "ok".tr.toUpperCase(),
                                                                  style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                                                ),
                                                        ),
                                                      ),
                                                    ],
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
                                                  title: "do you want to apply?".tr,
                                                  onPressed: () {
                                                    Get.back();
                                                    isEmployee
                                                        ? controller.acceptOrderCompany()
                                                        : controller.acceptOrderDriver();
                                                  },
                                                  //todo(later): handle cache orders
                                                  // content: controller.isLoadingCurr
                                                  //     ? SpinKitSquareCircle(color: cs.primary, size: 26)
                                                  //     : controller.currOrders.isEmpty
                                                  //         ? null
                                                  //         : Padding(
                                                  //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  //             child: SizedBox(
                                                  //               height: MediaQuery.of(context).size.height / 2,
                                                  //               width: MediaQuery.of(context).size.width / 1.5,
                                                  //               child: Column(
                                                  //                 children: [
                                                  //                   Padding(
                                                  //                     padding: const EdgeInsets.all(8.0),
                                                  //                     child: Text(
                                                  //                       "you currently have these orders".tr,
                                                  //                       style:
                                                  //                           tt.titleSmall!.copyWith(color: cs.onSurface),
                                                  //                     ),
                                                  //                   ),
                                                  //                   Expanded(
                                                  //                     child: ListView.builder(
                                                  //                       itemCount: controller.currOrders.length,
                                                  //                       itemBuilder: (context, i) => MiniOrderCard(
                                                  //                         order: controller.currOrders[i],
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                 ],
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      child: Center(
                                        child: controller.isLoadingSubmit || !oC.isMapReady
                                            ? SpinKitThreeBounce(color: cs.onPrimary, size: 20)
                                            : Text(
                                                "apply".tr.toUpperCase(),
                                                style: tt.titleSmall!.copyWith(color: cs.onPrimary),
                                              ),
                                      ),
                                    ),
                                  ),
                                //for company: show the name of the driver ("driver" didnt start the order yet)
                                /// start order & cancel with penalty
                                ///
                                if (!isCustomer &&
                                    !isCompany &&
                                    oC.order!.status == "approved" &&
                                    oC.order!.driverApproved)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
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
                                        Expanded(
                                          child: mainButton(
                                            color: Colors.red,
                                            alertDialog: alertDialog(
                                              onPressed: () {
                                                Get.back();

                                                controller.cancelOrder();
                                              },
                                              content: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  "${"if you cancel you will get penalty after".tr}  ${3 - controller.remainingCancels} "
                                                          " ${"times of cancel".tr}"
                                                      .tr,
                                                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                ),
                                              ),
                                              title: "cancel the order?".tr,
                                            ),
                                            isLoading: controller.isLoadingSubmit,
                                            buttonText: "cancel".tr.toUpperCase(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                /// finish order button
                                ///
                                if (!isCustomer && !isCompany && oC.order!.status == "processing")
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
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

                                /// add note button
                                ///
                                if (oC.order!.canAddNotes)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: CustomButton(
                                      onTap: () async {
                                        showMaterialModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          barrierColor: Colors.black.withValues(alpha: 0.5),
                                          enableDrag: false,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: const AddNoteSheet(),
                                          ),
                                        );
                                      },
                                      color: cs.primaryContainer,
                                      child: Center(
                                        child: Text(
                                          "add note".tr,
                                          style: tt.labelMedium!
                                              .copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),

                                /// cancel order button (wait 10 minutes to cancel if not approved yet)
                                /// todo(later) loading indicator not appearing in this button
                                if (!isCustomer &&
                                    oC.order!.status == "waiting_approval" &&
                                    !oC.order!.isCancelledByMe &&
                                    oC.order!.isAppliedByMe)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: mainButton(
                                      color: controller.canCancel ? Colors.red : Colors.grey,
                                      onPressed: !controller.canCancel
                                          ? null
                                          : () {
                                              Get.back();
                                              controller.cancelOrder();
                                            },
                                      alertDialog: alertDialog(
                                        onPressed: !controller.canCancel
                                            ? null
                                            : () {
                                                Get.back();
                                                controller.cancelOrder();
                                              },
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            "do you want to cancel the order?".tr,
                                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                          ),
                                        ),
                                        title: "cancel the order?".tr,
                                      ),
                                      isLoading: controller.isLoadingSubmit,
                                      buttonText: "cancel".tr.toUpperCase(),
                                    ),
                                  ),

                                /// cancel with penalty
                                /// todo check if you can cancel when accepted in driver  case
                                // if ((isCustomer && oC.order!.status == "waiting_approval") ||
                                //     (!isCustomer && oC.order!.status == "approved"))
                                if (isCustomer && oC.order!.status == "waiting_approval")
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: mainButton(
                                      color: Colors.red,
                                      alertDialog: alertDialog(
                                        onPressed: () {
                                          Get.back();

                                          controller.cancelOrder();
                                        },
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            "${"if you cancel you will get penalty after".tr}  ${3 - controller.remainingCancels} "
                                                    " ${"times of cancel".tr}"
                                                .tr,
                                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                          ),
                                        ),
                                        title: "cancel the order?".tr,
                                      ),
                                      isLoading: controller.isLoadingSubmit,
                                      buttonText: "cancel".tr.toUpperCase(),
                                    ),
                                  ),

                                ///map
                                ///
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 4, left: 4, right: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cs.secondaryContainer,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2), // Shadow color
                                          blurRadius: 2, // Soften the shadow
                                          spreadRadius: 1, // Extend the shadow
                                          offset: const Offset(1, 1), // Shadow direction (x, y)
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                        //   child: Text(
                                        //     "location".tr,
                                        //     style: tt.labelMedium!
                                        //         .copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                        //   ),
                                        // ),
                                        // Divider(
                                        //   thickness: 1.5,
                                        //   color: cs.onSecondaryContainer.withValues(alpha: 0.1),
                                        //   indent: 12,
                                        //   endIndent: 12,
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height / 5,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xff0e5aa6), width: 2.5),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: map(),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12.0, right: 12, top: 4),
                                          child: CustomButton(
                                            onTap: () async {
                                              if (controller.isMapReady) Get.to(TrackingView(map: map()));
                                              //controller.connectTrackingSocket();
                                            },
                                            isShort: true,
                                            //isGradiant: true,
                                            color: cs.primary,
                                            child: Center(
                                              child: Text(
                                                isCustomer && oC.order!.status == "processing"
                                                    ? "live tracking".tr.toUpperCase()
                                                    : "open map".tr,
                                                style: tt.labelMedium!
                                                    .copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: cs.onSecondaryContainer.withValues(alpha: 0.1),
                                          thickness: 1.5,
                                          indent: 12,
                                          endIndent: 12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${"starting point".tr.toUpperCase()}:",
                                                style: tt.labelMedium!.copyWith(
                                                  color: cs.onSecondaryContainer.withValues(alpha: 0.7),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  oC.order!.startPoint.toString(),
                                                  style: tt.labelMedium!.copyWith(
                                                      color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${"destination point".tr.toUpperCase()}:",
                                                style: tt.labelMedium!.copyWith(
                                                  color: cs.onSecondaryContainer.withValues(alpha: 0.7),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  oC.order!.endPoint.toString(),
                                                  style: tt.labelMedium!.copyWith(
                                                      color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),

                                ///drivers applications
                                ///
                                if ((isCustomer || isCompany) && controller.order!.driversApplications.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4, left: 4, top: 12, bottom: 4),
                                    child: TitledScrollingCard(
                                      title: isCompany ? "responsible captain".tr : "drivers applications".tr,
                                      itemCount: controller.order!.driversApplications.length,
                                      isEmpty: controller.order!.driversApplications.isEmpty,
                                      children: List.generate(
                                        controller.order!.driversApplications.length,
                                        (i) => ApplicationCard(
                                          isOrderCanceled: oC.order!.status == "canceled",
                                          showButtons:
                                              isCompany ? false : controller.order!.status == "waiting_approval",
                                          application: controller.order!.driversApplications[i],
                                          isAccepted: isCompany
                                              ? false
                                              : controller.order!.driversApplications[i].id ==
                                                  controller.order!.acceptedApplication?.id,
                                          onTapCall: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => callDialog(
                                                  controller.order!.driversApplications[i].driver.phoneNumber),
                                            );
                                          },
                                          onTapAccept: () {
                                            if (!oC.isMapReady) return;
                                            //doesnt close sometimes after confirm
                                            showDialog(
                                              context: context,
                                              builder: (context) => alertDialog(
                                                onPressed: () {
                                                  controller.confirmOrderCustomer(
                                                      controller.order!.driversApplications[i].id);
                                                  Get.back();
                                                },
                                                title: "accept the order?".tr,
                                              ),
                                            );
                                          },
                                          onSeePhone: () {
                                            if (!oC.isMapReady) return;
                                            showDialog(
                                              context: context,
                                              builder: (context) => alertDialog(
                                                onPressed: () {
                                                  Get.back();
                                                  controller
                                                      .allowToSeePhone(controller.order!.driversApplications[i].id);
                                                },
                                                title: "allow driver to see your phone?".tr,
                                              ),
                                            );
                                          },
                                          onTapRefuse: () {
                                            if (!oC.isMapReady) return;
                                            showDialog(
                                              context: context,
                                              builder: (context) => alertDialog(
                                                onPressed: () {
                                                  Get.back();
                                                  controller
                                                      .rejectOrderCustomer(controller.order!.driversApplications[i].id);
                                                },
                                                title: "refuse the order?".tr,
                                              ),
                                            );
                                          },
                                          onTapCard: () {
                                            showMaterialModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.transparent,
                                              barrierColor: Colors.black.withValues(alpha: 0.5),
                                              enableDrag: true,
                                              builder: (context) => BlurredSheet(
                                                title: "driver info".tr,
                                                confirmText: "ok".tr,
                                                onConfirm: () {
                                                  Get.back();
                                                },
                                                content: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: SheetDetailsTile(
                                                            title: "name".tr,
                                                            subtitle:
                                                                controller.order!.driversApplications[i].driver.name,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SheetDetailsTile(
                                                            title: "phone".tr,
                                                            subtitle: controller
                                                                .order!.driversApplications[i].driver.phoneNumber,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: SheetDetailsTile(
                                                            title: "submission date".tr,
                                                            subtitle: Jiffy.parseFromDateTime(
                                                                    controller.order!.driversApplications[i].appliedAt)
                                                                .format(pattern: "d / M / y"),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SheetDetailsTile(
                                                            title: "submission time".tr,
                                                            subtitle: Jiffy.parseFromDateTime(
                                                                    controller.order!.driversApplications[i].appliedAt)
                                                                .jm,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: SheetDetailsTile(
                                                            title: "vehicle type".tr,
                                                            subtitle: controller
                                                                .order!.driversApplications[i].vehicle.vehicleType.type,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: SheetDetailsTile(
                                                            title: "license plate".tr,
                                                            subtitle: controller.order!.driversApplications[i].vehicle
                                                                .vehicleRegistrationNumber,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SheetDetailsTile(
                                                      title: "rating".tr,
                                                      subtitle: controller
                                                          .order!.driversApplications[i].driver.overallRating
                                                          .toStringAsPrecision(2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          isLast: i == controller.order!.driversApplications.length - 1,
                                        ),
                                      ),
                                    ),
                                  ),

                                ///stepper
                                ///
                                // Container(
                                //   margin: const EdgeInsets.symmetric(horizontal: 4),
                                //   decoration: BoxDecoration(
                                //     color: cs.secondaryContainer,
                                //     borderRadius: BorderRadius.circular(10),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.black.withOpacity(0.2), // Shadow color
                                //         blurRadius: 2, // Soften the shadow
                                //         spreadRadius: 1, // Extend the shadow
                                //         offset: Offset(1, 1), // Shadow direction (x, y)
                                //       ),
                                //     ],
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Padding(
                                //         padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                //         child: Text(
                                //           "order status".tr,
                                //           style:
                                //               tt.labelMedium!.copyWith(color: cs.onSurface, fontWeight: FontWeight.bold),
                                //         ),
                                //       ),
                                //       Divider(
                                //         thickness: 1.5,
                                //         color: cs.onSecondaryContainer.withOpacity(0.1),
                                //         indent: 12,
                                //         endIndent: 12,
                                //       ),
                                //       Stepper(
                                //         controlsBuilder: (BuildContext context, ControlsDetails details) {
                                //           return const SizedBox.shrink(); // Removes buttons
                                //         },
                                //         physics: const NeverScrollableScrollPhysics(),
                                //         steps: List.generate(
                                //           controller.statuses.length,
                                //           (i) {
                                //             List icons = [
                                //               StepState.complete,
                                //               StepState.complete,
                                //               StepState.complete,
                                //               StepState.disabled,
                                //               StepState.disabled,
                                //             ];
                                //             return Step(
                                //                 state: icons[i], // Shows simple circle instead of interactive
                                //                 // icon
                                //                 isActive: false, // Makes step appear inactive
                                //                 title: Text(
                                //                   controller.statuses[i].tr,
                                //                   style: tt.labelMedium!.copyWith(
                                //                       color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                //                 ),
                                //                 content: SizedBox(
                                //                   width: double.infinity,
                                //                   height: 0,
                                //                 ),
                                //                 subtitle: Text(
                                //                   i % 2 == 0
                                //                       ? controller.order!.fullDate()
                                //                       : controller.order!.fullCreationDate(),
                                //                   style: tt.labelSmall!.copyWith(
                                //                       color: cs.onSecondaryContainer, fontWeight: FontWeight.normal),
                                //                 ),
                                //                 stepStyle: StepStyle(
                                //                   color: i > 2 ? Colors.grey : cs.primary,
                                //                 )
                                //                 // subtitle: Text(
                                //                 //   "",
                                //                 //   style: tt.labelMedium!
                                //                 //       .copyWith(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
                                //                 // ),
                                //                 );
                                //           },
                                //         ),
                                //
                                //         onStepTapped: null, // Disables tapping on steps
                                //         onStepCancel: null, // Disables cancel action
                                //         onStepContinue: null, // Disables continue action
                                //         currentStep: 2, // Set to whatever step should appear as "current"
                                //       ),
                                //     ],
                                //   ),
                                // ),
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

                                // Padding(
                                //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                                //   child: Divider(
                                //     thickness: 2,
                                //     color: cs.primary,
                                //     indent: 80,
                                //     endIndent: 80,
                                //   ),
                                // ),
                                // const SizedBox(height: 12),

                                ///customer info
                                ///
                                if (!isCustomer)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0, right: 4, left: 4),
                                    child: TitledCard(
                                      title: "owner info".tr,
                                      content: ApplicationCard2(
                                        title: oC.order!.orderOwner?.name ?? "",
                                        //showButtons: (["processing", "done", "approved"].contains(oC.order!.status)),
                                        showButtons: controller.order!.driversApplications.isNotEmpty &&
                                            controller.order!.driversApplications.first.canSeePhone &&
                                            !controller.order!.isCancelledByMe,
                                        isLast: true,
                                        onTapCall: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => callDialog(controller.order!.orderOwner!.phoneNumber),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                /// available payment methods
                                ///
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 4, right: 4, left: 4),
                                  child: TitledCard(
                                    title: "payment methods".tr,
                                    content: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Wrap(
                                          spacing: 8,
                                          children: List.generate(
                                            controller.order!.paymentMethods.length,
                                            (i) => GestureDetector(
                                              onTap: () {
                                                if (["approved", "processing", "done"]
                                                        .contains(controller.order!.status) &&
                                                    controller.order!.paymentMethods[i].payment.fullName != null) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => alertDialog(
                                                        title: "details".tr,
                                                        cancelText: "ok".tr,
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            DetailsTile(
                                                              //iconData: Icons.description_outlined,
                                                              title: "full name".tr,
                                                              subtitle:
                                                                  controller.order!.paymentMethods[i].payment.fullName!,
                                                            ),
                                                            DetailsTile(
                                                              //iconData: Icons.attach_money,
                                                              title: controller.order!.paymentMethods[i].payment
                                                                          .phoneNumber ==
                                                                      null
                                                                  ? "account details".tr
                                                                  : "phone".tr,
                                                              subtitle: controller
                                                                      .order!.paymentMethods[i].payment.phoneNumber ??
                                                                  controller.order!.paymentMethods[i].payment
                                                                      .accountDetails ??
                                                                  '',
                                                            ),
                                                          ],
                                                        )),
                                                  );
                                                  // showPopover(
                                                  //   context: context,
                                                  //   backgroundColor: cs.surface,
                                                  //   bodyBuilder: (context) => Padding(
                                                  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                                  //     child: Text(
                                                  //       controller.order!.paymentMethods[i].payment.fullName! +
                                                  //           "\n" +
                                                  //           (controller.order!.paymentMethods[i].payment.phoneNumber ??
                                                  //               controller
                                                  //                   .order!.paymentMethods[i].payment.accountDetails ??
                                                  //               ''),
                                                  //       style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                                  //       overflow: TextOverflow.ellipsis,
                                                  //       maxLines: 4,
                                                  //     ),
                                                  //   ),
                                                  // );
                                                }
                                              },
                                              child: Chip(
                                                label: Text(
                                                  controller.order!.paymentMethods[i].payment.methodName,
                                                  style: tt.labelSmall!.copyWith(
                                                      color: controller.order!.paymentMethods[i].isActive
                                                          ? cs.onPrimary
                                                          : cs.onSecondaryContainer),
                                                ),
                                                backgroundColor: controller.order!.paymentMethods[i].isActive
                                                    ? cs.primary
                                                    : cs.secondaryContainer,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),

                                ///details
                                ///
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 16, right: 4, left: 4),
                                  child: TitledCard(
                                    title: "details".tr,
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          DetailsTile(
                                            iconData: Icons.description_outlined,
                                            title: "package type".tr,
                                            subtitle: controller.order!.description,
                                          ),
                                          DetailsTile(
                                            iconData: Icons.attach_money,
                                            title: "price".tr,
                                            subtitle: controller.order!.fullPrice(),
                                          ),
                                          DetailsTile(
                                            iconData: Icons.local_shipping,
                                            title: "required vehicle type".tr,
                                            subtitle: controller.order!.typeVehicle.type,
                                          ),
                                          if (oC.order!.extraInfo.isNotEmpty)
                                            Divider(
                                              color: cs.onSecondaryContainer.withValues(alpha: 0.1),
                                              thickness: 1.5,
                                              indent: 12,
                                              endIndent: 12,
                                            ),
                                          if (oC.order!.extraInfo.isNotEmpty || oC.order!.otherInfo != null)
                                            const SizedBox(height: 8),
                                          if (oC.order!.extraInfo.isNotEmpty)
                                            Wrap(
                                                children: oC.order!.extraInfo
                                                    .map(
                                                      (e) => Padding(
                                                        padding: const EdgeInsets.only(left: 40.0, bottom: 12),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 4.0),
                                                              child: CircleAvatar(
                                                                foregroundColor: cs.secondaryContainer,
                                                                backgroundColor: cs.primaryContainer,
                                                                radius: 6,
                                                                child: const Icon(Icons.done, size: 10),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              e.name,
                                                              style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1000,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList()),
                                          if (oC.order!.otherInfo != null)
                                            Text(
                                              oC.order!.otherInfo!,
                                              style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1000,
                                            ),
                                          if (oC.order!.otherInfo != null) const SizedBox(height: 8),
                                          Divider(
                                            color: cs.onSecondaryContainer.withValues(alpha: 0.1),
                                            thickness: 1.5,
                                            indent: 12,
                                            endIndent: 12,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    //
                                                    Text(
                                                      "${"weight".tr}: ",
                                                      style: tt.labelMedium!.copyWith(
                                                        color: cs.onSecondaryContainer,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "${"arrive date".tr}: ",
                                                      style: tt.labelMedium!.copyWith(
                                                        color: cs.onSecondaryContainer,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "${"added at".tr}: ",
                                                      style: tt.labelMedium!.copyWith(
                                                        color: cs.onSecondaryContainer,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                    //
                                                  ],
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        oC.order!.fullWeight(),
                                                        style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
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
                                                          // Visibility(
                                                          //   visible: oC.order!.dateTime.isBefore(DateTime.now()) &&
                                                          //       !["draft", "done"].contains(oC.order!.status),
                                                          //   child: GestureDetector(
                                                          //     onTap: () {
                                                          //       showPopover(
                                                          //         context: context,
                                                          //         backgroundColor: cs.surface,
                                                          //         bodyBuilder: (context) => Padding(
                                                          //           padding: const EdgeInsets.symmetric(
                                                          //               horizontal: 12, vertical: 16),
                                                          //           child: Text(
                                                          //             "order was not accepted in time".tr,
                                                          //             style:
                                                          //                 tt.titleMedium!.copyWith(color: cs.onSurface),
                                                          //             overflow: TextOverflow.ellipsis,
                                                          //             maxLines: 2,
                                                          //           ),
                                                          //         ),
                                                          //       );
                                                          //     },
                                                          //     child: Icon(Icons.info, color: cs.error, size: 18),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        oC.order!.fullCreationDate(),
                                                        style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                //   margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.black.withOpacity(0.2), // Shadow color
                                //         blurRadius: 3, // Soften the shadow
                                //         spreadRadius: 1, // Extend the shadow
                                //         //offset: const Offset(2, 2), // Shadow direction (x, y)
                                //       ),
                                //     ],
                                //     color: cs.secondaryContainer,
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Row(
                                //         children: [
                                //           Icon(Icons.text_snippet, color: cs.primary),
                                //           const SizedBox(width: 8),
                                //           Text(
                                //             "details".tr,
                                //             style: tt.titleLarge!.copyWith(color: cs.onSecondaryContainer),
                                //             overflow: TextOverflow.ellipsis,
                                //           ),
                                //         ],
                                //       ),
                                //       const SizedBox(height: 16),
                                //       if (oC.order!.extraInfo.isNotEmpty)
                                //         Text(
                                //           oC.order!.formatExtraInfo(),
                                //           style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                //           overflow: TextOverflow.ellipsis,
                                //           maxLines: 1000,
                                //         ),
                                //       if (oC.order!.otherInfo != null)
                                //         Text(
                                //           oC.order!.otherInfo!,
                                //           style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                //           overflow: TextOverflow.ellipsis,
                                //           maxLines: 1000,
                                //         ),
                                //       const SizedBox(height: 12),
                                //       Padding(
                                //         padding: const EdgeInsets.symmetric(vertical: 4),
                                //         child: Row(
                                //           children: [
                                //             Text(
                                //               "${"weight".tr}: ",
                                //               style: tt.titleSmall!.copyWith(
                                //                 color: cs.onSecondaryContainer,
                                //                 fontWeight: FontWeight.bold,
                                //               ),
                                //               overflow: TextOverflow.ellipsis,
                                //               maxLines: 3,
                                //             ),
                                //             const SizedBox(width: 8),
                                //             SizedBox(
                                //               width: MediaQuery.of(context).size.width / 1.8,
                                //               child: Text(
                                //                 "${oC.order!.weight} ${oC.order!.weightUnit}",
                                //                 style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                //                 overflow: TextOverflow.ellipsis,
                                //                 maxLines: 1,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       Padding(
                                //         padding: const EdgeInsets.symmetric(vertical: 4),
                                //         child: Row(
                                //           children: [
                                //             Expanded(
                                //               child: Row(
                                //                 children: [
                                //                   Text(
                                //                     "${"expected arrive date".tr}: ",
                                //                     style: tt.titleSmall!.copyWith(
                                //                       color: cs.onSecondaryContainer,
                                //                       fontWeight: FontWeight.bold,
                                //                     ),
                                //                     overflow: TextOverflow.ellipsis,
                                //                     maxLines: 2,
                                //                   ),
                                //                   const SizedBox(width: 8),
                                //                   Text(
                                //                     oC.order!.fullDate(),
                                //                     style: tt.labelMedium!.copyWith(
                                //                       color: oC.order!.dateTime.isBefore(DateTime.now()) &&
                                //                               !["draft", "done"].contains(oC.order!.status)
                                //                           ? cs.error
                                //                           : cs.onSurface,
                                //                     ),
                                //                     overflow: TextOverflow.ellipsis,
                                //                     maxLines: 1,
                                //                   ),
                                //                   const SizedBox(width: 12),
                                //                   Visibility(
                                //                     visible: oC.order!.dateTime.isBefore(DateTime.now()) &&
                                //                         !["draft", "done"].contains(oC.order!.status),
                                //                     child: GestureDetector(
                                //                       onTap: () {
                                //                         showPopover(
                                //                           context: context,
                                //                           backgroundColor: cs.surface,
                                //                           bodyBuilder: (context) => Padding(
                                //                             padding:
                                //                                 const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                //                             child: Text(
                                //                               "order was not accepted in time".tr,
                                //                               style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                //                               overflow: TextOverflow.ellipsis,
                                //                               maxLines: 2,
                                //                             ),
                                //                           ),
                                //                         );
                                //                       },
                                //                       child: Icon(Icons.info, color: cs.error, size: 18),
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       Padding(
                                //         padding: const EdgeInsets.symmetric(vertical: 4),
                                //         child: Row(
                                //           children: [
                                //             Text(
                                //               "${"added at".tr}: ",
                                //               style: tt.titleSmall!.copyWith(
                                //                 color: cs.onSecondaryContainer,
                                //                 fontWeight: FontWeight.bold,
                                //               ),
                                //               overflow: TextOverflow.ellipsis,
                                //               maxLines: 2,
                                //             ),
                                //             const SizedBox(width: 8),
                                //             Expanded(
                                //               child: Text(
                                //                 oC.order!.fullCreationDate(),
                                //                 style: tt.labelMedium!.copyWith(color: cs.onSurface),
                                //                 overflow: TextOverflow.ellipsis,
                                //                 maxLines: 2,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(height: 24),

                                /// notes
                                ///
                                if (controller.order!.status == "done")
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 4, left: 4),
                                    child: MultiTitledCard(
                                      titles: isCompany
                                          ? ["driver notes".tr, "customer notes".tr]
                                          : isCustomer
                                              ? ["my notes".tr, "driver notes".tr]
                                              : ["my notes".tr, "customer notes".tr],
                                      contents: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(
                                            isCompany
                                                ? controller.order!.driverNotes.length
                                                : controller.order!.myNotes.length,
                                            (i) => Padding(
                                              padding: const EdgeInsets.only(bottom: 6.0, left: 12, right: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 8,
                                                    backgroundColor: cs.primaryContainer,
                                                    child: Icon(
                                                      Icons.done,
                                                      color: cs.secondaryContainer,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      isCompany
                                                          ? controller.order!.driverNotes[i].note
                                                          : controller.order!.myNotes[i].note,
                                                      style: tt.labelMedium!.copyWith(color: cs.onSecondaryContainer),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(
                                            isCompany
                                                ? controller.order!.customerNotes.length
                                                : isCustomer
                                                    ? controller.order!.driverNotes.length
                                                    : controller.order!.customerNotes.length,
                                            (i) => Padding(
                                              padding: const EdgeInsets.only(bottom: 6.0, left: 12, right: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 8,
                                                    backgroundColor: cs.primaryContainer,
                                                    child: Icon(
                                                      Icons.done,
                                                      color: cs.secondaryContainer,
                                                      size: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      isCompany
                                                          ? controller.order!.customerNotes[i].note
                                                          : isCustomer
                                                              ? controller.order!.driverNotes[i].note
                                                              : controller.order!.customerNotes[i].note,
                                                      style: tt.labelMedium!.copyWith(color: cs.onSecondaryContainer),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            if (!isCustomer &&
                                oC.order!.status == "pending" &&
                                oC.order!.ownerApproved &&
                                !oC.order!.driverApproved)
                              Positioned(
                                top: 0,
                                left: 20,
                                right: 20,
                                child: alertStack(
                                  title: "${oC.order!.orderOwner?.name ?? "order owner is null"}"
                                      " ${"accepted your request".tr}",
                                  greenText: 'accept'.tr,
                                  redText: 'cancel'.tr,
                                  onPressedGreen: () {
                                    Get.back();
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
                                                  // todo replace deprecated
                                                  // todo: not drawing path for employee (driver home), try in driver
                                                  // todo: fix crash (all buttons)
                                                  // todo dont let show number fast before accept (until map is ready)
                                                  // RadioGroup<PaymentMethod>(
                                                  //   groupValue: controller.selectedPayment,
                                                  //   onChanged: (PaymentMethod? method) {
                                                  //     if (method != null) {
                                                  //       controller.selectPayment(method);
                                                  //     }
                                                  //   },
                                                  //   child: Column(
                                                  //     children: oC.order!.paymentMethods.map((payment) {
                                                  //       return Radio<PaymentMethod>(
                                                  //         value: payment,
                                                  //         child: ListTile(
                                                  //           title: Text(
                                                  //             payment.payment.methodName,
                                                  //             style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                  //           ),
                                                  //         ),
                                                  //       );
                                                  //     }).toList(),
                                                  //   ),
                                                  // ),

                                                  Visibility(
                                                    visible: ["Bank Account", "Money Transfer"]
                                                        .contains(controller.selectedPayment.payment.methodValue),
                                                    child: InputField(
                                                      controller: controller.fullName,
                                                      label: "full name".tr,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.next,
                                                      prefixIcon: Icons.person,
                                                      validator: (val) {
                                                        if (!["Bank Account", "Money Transfer"]
                                                            .contains(controller.selectedPayment.payment.methodValue)) {
                                                          return null;
                                                        }
                                                        return validateInput(controller.fullName.text, 0, 100, "");
                                                      },
                                                      onChanged: (val) {
                                                        if (controller.buttonPressed) {
                                                          controller.formKey.currentState!.validate();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: ["Bank Account"]
                                                        .contains(controller.selectedPayment.payment.methodValue),
                                                    child: InputField(
                                                      controller: controller.accountDetails,
                                                      label: "account details".tr,
                                                      keyboardType: TextInputType.text,
                                                      textInputAction: TextInputAction.next,
                                                      prefixIcon: Icons.short_text_outlined,
                                                      validator: (val) {
                                                        if (!["Bank Account"]
                                                            .contains(controller.selectedPayment.payment.methodValue)) {
                                                          return null;
                                                        }
                                                        return validateInput(
                                                            controller.accountDetails.text, 0, 100, "");
                                                      },
                                                      onChanged: (val) {
                                                        if (controller.buttonPressed) {
                                                          controller.formKey.currentState!.validate();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: ["Money Transfer"]
                                                        .contains(controller.selectedPayment.payment.methodValue),
                                                    child: InputField(
                                                      controller: controller.phoneNumber,
                                                      label: "phone number".tr,
                                                      keyboardType: TextInputType.number,
                                                      textInputAction: TextInputAction.next,
                                                      prefixIcon: Icons.phone_android,
                                                      validator: (val) {
                                                        if (!["Money Transfer"]
                                                            .contains(controller.selectedPayment.payment.methodValue)) {
                                                          return null;
                                                        }
                                                        return validateInput(
                                                            controller.phoneNumber.text, 0, 12, "phone");
                                                      },
                                                      onChanged: (val) {
                                                        if (controller.buttonPressed) {
                                                          controller.formKey.currentState!.validate();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  CustomButton(
                                                    color: cs.primaryContainer,
                                                    onTap: () {
                                                      if (!oC.isMapReady) return;
                                                      isCompany || isEmployee
                                                          ? controller.confirmOrderCompany()
                                                          : controller.confirmOrderDriver();
                                                    },
                                                    child: Center(
                                                      child: controller.isLoadingSubmit || !oC.isMapReady
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
                                    controller.cancelOrder();
                                  },
                                  isLoadingGreen: controller.isLoadingSubmit,
                                  isLoadingRed: controller.isLoadingRefuse,
                                ),
                              ),

                            if (isCustomer && oC.order!.status == "done" && controller.showRatingBox)
                              Positioned(
                                top: 0,
                                left: 20,
                                right: 20,
                                child: alertStack(
                                  title: "do you want to rate your experience with the driver?".tr,
                                  onPressedGreen: () {
                                    Get.dialog(AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text(
                                        "rate your experience".tr,
                                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: 0, //show the user previous rating
                                            glow: false,
                                            itemSize: 25,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              controller.setRating(rating.toInt());
                                            },
                                          ),
                                          SingleChildScrollView(
                                            child: TextField(
                                              controller: controller.comment,
                                              minLines: 1,
                                              maxLines: 4,
                                              keyboardType: TextInputType.multiline,
                                              decoration: InputDecoration(
                                                hintText: "comment (optional)".tr,
                                                hintStyle:
                                                    tt.titleSmall!.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                                                label: Text(
                                                  "comment".tr,
                                                  style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                                ),
                                              ),
                                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                              onChanged: (String? s) {
                                                //
                                              },
                                              obscureText: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            controller.rateOrder();
                                          },
                                          child: Text(
                                            "submit".tr,
                                            style: tt.titleSmall!.copyWith(color: cs.primary),
                                          ),
                                        ),
                                      ],
                                    ));
                                  },
                                  onPressedRed: () {
                                    controller.setShowRatingBox(false);
                                  },
                                  isLoadingGreen: controller.isLoadingSubmit,
                                  isLoadingRed: controller.isLoadingRefuse,
                                  greenText: 'yes'.tr,
                                  redText: 'no'.tr,
                                  showWarningDialogs: false,
                                ),
                              ),
                          ],
                        ),
                ),
        ),
      );
    });
  }
}

class DetailsTile extends StatelessWidget {
  final IconData? iconData;
  final String title;
  final String subtitle;

  const DetailsTile({
    super.key,
    this.iconData,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: cs.primaryContainer,
              size: 20,
            ),
          if (iconData != null) const SizedBox(width: 6),
          Text(
            "$title: ",
            style: tt.labelMedium!.copyWith(
              color: cs.onSecondaryContainer.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              subtitle,
              style: tt.labelMedium!.copyWith(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
