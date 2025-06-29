import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shipment/controllers/filter_controller.dart';
import 'package:shipment/controllers/home_navigation_controller.dart';
// import 'package:shipment/models/order_model.dart';
import '../models/order_model_2.dart';
import '../models/user_model.dart';
import '../services/remote_services.dart';
import '../views/login_view.dart';
import '../views/otp_view.dart';
import 'login_controller.dart';
import 'otp_controller.dart';

class CustomerHomeController extends GetxController {
  CustomerHomeController();

  @override
  onInit() {
    //
    super.onInit();
  }
}
