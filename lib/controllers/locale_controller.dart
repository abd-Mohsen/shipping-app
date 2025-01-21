import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  final _getStorage = GetStorage();
  late Locale _initLocale;
  Locale get initialLang => _initLocale;

  LocaleController() {
    loadInitLocale();
  }

  void updateLocale(String langCode) {
    _getStorage.write("lang", langCode);
    Get.updateLocale(Locale(langCode));
  }

  String getCurrentLanguageLabel() {
    final currentLang = _getStorage.read("lang");
    if (currentLang == "ar") {
      return "Arabic".tr;
    } else if (currentLang == "en") {
      return "English".tr;
    } else {
      return Get.deviceLocale!.languageCode == "ar" ? "Arabic ".tr : "English ".tr;
    }
  }

  void loadInitLocale() {
    _initLocale = Locale(_getStorage.read("lang") ?? Get.deviceLocale!.languageCode);
  }
}
