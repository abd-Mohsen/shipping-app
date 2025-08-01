import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shipment/services/notifications_service.dart';
import 'package:shipment/themes.dart';
import 'package:shipment/views/redirect_page.dart';
import 'api.dart';
import 'package:get/get.dart';
import 'controllers/locale_controller.dart';
import 'controllers/theme_controller.dart';
import 'firebase_options.dart';
import 'locale.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final Api api = Api();
final NotificationService notificationService = NotificationService();
//todo: additional notes (tele pins)
//todo: PT report
//todo(later): reduce apk size
//todo(later): handle big font size

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black, // Set your desired color //todo: not working
    statusBarIconBrightness: Brightness.light, // For dark status bar icons
    // or Brightness.dark for light icons
  ));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseApp app = Firebase.app();
  print('Firebase app name: ${app.name}');
  print('Firebase app options: ${app.options}');
  await dotenv.load(fileName: ".env");
  notificationService.initNotification();
  //await Get.putAsync(() => ScreenService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeController t = Get.put(ThemeController());
    LocaleController l = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyLocale(),
      locale: l.initialLang,
      title: 'shipping',
      home: const RedirectPage(),
      theme: MyThemes.myLightMode, //custom light theme
      darkTheme: MyThemes.myDarkMode, //custom dark theme
      themeMode: t.getThemeMode(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          ///to make text factor 1 for all text widgets (user cant fuck it up from phone settings)
          data: MediaQuery.of(context).copyWith(devicePixelRatio: 1, textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
    );
  }
}
