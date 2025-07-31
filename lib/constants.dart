import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shipment/views/login_view.dart';

String kHostIP = "https://shipping.adadevs.com";

String kFontFamily = 'Alexandria';

Duration kTimeOutDurationLong = const Duration(seconds: 60);
Duration kTimeOutDuration = const Duration(seconds: 25);
Duration kTimeOutDuration2 = const Duration(seconds: 15);
Duration kTimeOutDuration3 = const Duration(seconds: 7);

AlertDialog kCloseAppDialog() => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      title: const Text("هل تريد الخروج من التطبيق؟", style: TextStyle(color: Colors.black)),
      actions: [
        TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text(
              "نعم",
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "لا",
              style: TextStyle(color: Colors.black),
            )),
      ],
    );

AlertDialog kSessionExpiredDialog() => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("انتهت صلاحية الجلسة", style: TextStyle(color: Colors.black)),
      content: const Text("من فضلك سجل دخول مرة أخرى", style: TextStyle(color: Colors.black)),
      actions: [
        TextButton(
            onPressed: () {
              Get.offAll(() => const LoginView());
            },
            child: const Text("ok", style: TextStyle(color: Colors.black))),
      ],
    );

AlertDialog kActivateAccountDialog() => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("حسابك غير مفعل", style: TextStyle(color: Colors.black)),
      content: const Text("يرجى التواصل مع شركة لتفعيل حسابك", style: TextStyle(color: Colors.black)),
      actions: [
        TextButton(
            onPressed: () {
              Get.offAll(() => const LoginView());
            },
            child: const Text("تسجيل خروج", style: TextStyle(color: Colors.red))),
      ],
    );

Widget kEnableLocationDialog(onConfirm) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text('location Required'.tr, style: const TextStyle(color: Colors.black)),
        content: Text('please enable location services then press ok'.tr, style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
            },
            child: Text("open settings".tr, style: const TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text("ok".tr, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

kTimeOutDialog() => Get.defaultDialog(
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: Colors.black),
      backgroundColor: Colors.white,
      title: "فشل الاتصال",
      middleText: "تأكد من اتصالك بالانترنت ثم حاول مجدداً",
    );

kTimeOutSnackBar() => Get.snackbar(
      "لا يوجد اتصال بالانترنت",
      "تأكد من اتصالك أو حاول لاحقاً ",
      icon: const Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.wifi_off, color: Colors.white),
      ),
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );

kServerErrorSnackBar() => Get.snackbar(
      "الخادم لا يستجيب",
      "الرجاء المحاولة لاحقاً",
      icon: const Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.storage, color: Colors.white),
      ),
      colorText: Colors.white,
      backgroundColor: Colors.deepOrangeAccent,
    );

TextTheme kMyTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontSize: 57,
    //wordSpacing: 64,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  displayMedium: TextStyle(
    fontSize: 45,
    //wordSpacing: 52,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  displaySmall: TextStyle(
    fontSize: 36,
    //wordSpacing: 44,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  headlineLarge: TextStyle(
    fontSize: 32,
    //wordSpacing: 40,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  headlineMedium: TextStyle(
    fontSize: 28,
    //wordSpacing: 36,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  headlineSmall: TextStyle(
    fontSize: 24,
    //wordSpacing: 32,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  titleLarge: TextStyle(
    fontSize: 22,
    //wordSpacing: 28,
    letterSpacing: 0,
    fontFamily: kFontFamily,
  ),
  titleMedium: TextStyle(
    fontSize: 18,
    //wordSpacing: 24,
    letterSpacing: 0.15,
    fontFamily: kFontFamily,
  ),
  titleSmall: TextStyle(
    fontSize: 14,
    //wordSpacing: 20,
    letterSpacing: 0.1,
    fontFamily: kFontFamily,
  ),
  labelLarge: TextStyle(
    fontSize: 14,
    //wordSpacing: 20,
    letterSpacing: 0.1,
    fontFamily: kFontFamily,
  ),
  labelMedium: TextStyle(
    fontSize: 12,
    //wordSpacing: 16,
    letterSpacing: 0.5,
    fontFamily: kFontFamily,
  ),
  labelSmall: TextStyle(
    fontSize: 11,
    //wordSpacing: 16,
    letterSpacing: 0.5,
    fontFamily: kFontFamily,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    //wordSpacing: 24,
    letterSpacing: 0.15,
    fontFamily: kFontFamily,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    //wordSpacing: 20,
    letterSpacing: 0.25,
    fontFamily: kFontFamily,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    //wordSpacing: 16,
    letterSpacing: 0.4,
    fontFamily: kFontFamily,
  ),
);

MarkerIcon kMapDefaultMarker = const MarkerIcon(
  iconWidget: Icon(
    Icons.location_on,
    color: Color(0xFFFF0000),
    size: 100,
  ),
);
MarkerIcon kMapDefaultMarkerBlue = const MarkerIcon(
  iconWidget: Icon(
    Icons.location_on,
    color: Color(0xFF38B6FF),
    size: 100,
  ),
);

MarkerIcon kMapDriverMarker = const MarkerIcon(
  iconWidget: Icon(
    Icons.local_shipping,
    color: Color(0xFFFF0000),
    size: 90,
  ),
);

MarkerIcon kMapSmallMarker = const MarkerIcon(
  iconWidget: Icon(
    Icons.location_on,
    color: Color(0xFFFF0000),
    size: 45,
  ),
);
MarkerIcon kMapSmallMarkerBlue = const MarkerIcon(
  iconWidget: Icon(
    Icons.location_on,
    color: Color(0xFF38B6FF),
    size: 45,
  ),
);

MarkerIcon kMapDriverSmallMarker = const MarkerIcon(
  iconWidget: Icon(
    Icons.local_shipping,
    color: Color(0xFFFF0000),
    size: 40,
  ),
);

MarkerIcon kCurrLocation = const MarkerIcon(
    iconWidget: CircleAvatar(
  backgroundColor: Color(0x660B5BA8),
  radius: 30,
  child: CircleAvatar(
    backgroundColor: Color(0xff0e5aa6),
    radius: 7,
  ),
));

MarkerIcon kCurrLocationBig = const MarkerIcon(
    iconWidget: CircleAvatar(
  backgroundColor: Color(0x660B5BA8),
  radius: 40,
  child: CircleAvatar(
    backgroundColor: Color(0xff0e5aa6),
    radius: 15,
  ),
));

const Color kNotificationColor = Color(0xffFFA500);
const Color kNotificationUnreadDarkColor = Color(0xff3f3f3f);
const Color kNotificationUnreadLightColor = Color(0xfff9f9e5);

Widget kEnableLocationDialog2(onConfirm) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text('location Required'.tr, style: const TextStyle(color: Colors.black)),
        content: Text('please enable location services then press ok'.tr, style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
            },
            child: Text("open settings".tr, style: const TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text("ok".tr, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

Widget kNoValidCarDialog(onConfirm) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text('cant use the app'.tr, style: const TextStyle(color: Colors.black)),
        content: Text(
            'you do not have a vehicle associated with your account, please register a vehicle to continue'.tr,
            style: const TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: onConfirm,
            child: Text("open settings".tr, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
