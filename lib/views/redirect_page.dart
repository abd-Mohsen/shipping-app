import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:shipment/controllers/customer_home_controller.dart';
import 'package:shipment/controllers/driver_home_controller.dart';
import 'package:shipment/views/notifications_view.dart';
import 'package:shipment/views/company_home_view.dart';
import 'package:shipment/views/customer_home_view.dart';
import 'package:shipment/views/driver_home_view.dart';
import 'package:shipment/views/login_view.dart';
import 'package:shipment/views/onboarding_view.dart';
import 'package:shipment/views/register_view.dart';
import 'package:showcaseview/showcaseview.dart';

import '../controllers/company_home_controller.dart';
import '../controllers/current_user_controller.dart';
import '../controllers/filter_controller.dart';
import '../controllers/home_navigation_controller.dart';
import '../controllers/my_vehicles_controller.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/online_socket_controller.dart';
import '../controllers/refresh_socket_controller.dart';
import '../controllers/shared_home_controller.dart';

class RedirectPage extends StatefulWidget {
  //todo: get the link from app-info and store it
  //todo: force update based on app version
  final bool? toNotifications;
  const RedirectPage({super.key, this.toNotifications});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  GetStorage getStorage = GetStorage();

  @override
  void initState() {
    getStorage.remove("from_register");

    if ((widget.toNotifications ?? false) && getStorage.hasData("token")) {
      Get.deleteAll();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToApp();
    });

    super.initState();
  }

  Future navigateToApp() async {
    !getStorage.hasData("token")
        ? !getStorage.hasData("onboarding")
            ? Get.to(() => const OnboardingView())
            : Get.to(() => ShowCaseWidget(builder: (context) {
                  return const LoginView();
                }))
        : getStorage.read("role") == null
            ? Get.to(() => ShowCaseWidget(builder: (context) {
                  return const RegisterView();
                }))
            : getStorage.read("role") == "driver" || getStorage.read("role") == "company_employee"
                ? Get.to(
                    () => ShowCaseWidget(builder: (context) {
                          return const DriverHomeView();
                        }),
                    binding: DriverBindings())
                : getStorage.read("role") == "customer"
                    ? Get.to(
                        () => ShowCaseWidget(builder: (context) {
                              return const CustomerHomeView();
                            }),
                        binding: CustomerBindings())
                    : getStorage.read("role") == "company"
                        ? Get.to(
                            () => ShowCaseWidget(builder: (context) {
                                  return const CompanyHomeView();
                                }),
                            binding: CompanyBindings())
                        : Get.to(() => const Placeholder());

    await Future.delayed(const Duration(milliseconds: 600));
    if ((widget.toNotifications ?? false) && getStorage.hasData("token")) {
      Get.to(const NotificationsView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/animations/simple truck.json") // Show loading indicator
          ),
    );
  }
}

//bool _isLoading = false;

// @override
// void initState() {
//   super.initState();
//
//   //_checkForUpdates();
//   //_navigateToApp();
// }

// Future<void> _checkForUpdates() async {
//   // Simulate a loading delay (e.g., 2 seconds)
//   //await Future.delayed(const Duration(seconds: 3));
//
//   // Get the current app version
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   String currentVersion = packageInfo.version;
//   print(currentVersion);
//
//   // Make an API request to check for updates
//   // final response = await http.get(
//   //   Uri.parse('https://your-server.com/check-update?current_version=$currentVersion'),
//   // );
//
//   // if (response.statusCode == 200) {
//   //   final data = jsonDecode(response.body);
//   //   // bool updateRequired = data['update_required'];
//   //   // String latestVersion = data['latest_version'];
//   //   // String downloadUrl = data['download_url'];
//   //
//   //   if (updateRequired) {
//   //     _showUpdateDialog(latestVersion, downloadUrl);
//   //   } else {
//   //     // No update required, proceed to the app
//   _navigateToApp();
//   //   }
//   // } else {
//   //   _showErrorDialog();
//   // }
//
//   setState(() {
//     _isLoading = false;
//   });
// }
//
// void _showUpdateDialog(String latestVersion, String downloadUrl) {
//   showDialog(
//     context: context,
//     barrierDismissible: false, // Prevent user from dismissing the dialog
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Update Required'),
//         content: Text('A new version ($latestVersion) is available. Please update to continue.'),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               // Open the download URL in the browser
//               if (await canLaunchUrl(Uri.parse(downloadUrl))) {
//                 await launchUrl(Uri.parse(downloadUrl));
//               } else {
//                 // Handle error (e.g., show a message)
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Could not launch the download URL.')),
//                 );
//               }
//             },
//             child: const Text('Update Now'),
//           ),
//         ],
//       );
//     },
//   );
// }
//
// void _showErrorDialog() {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Error'),
//         content: const Text('Failed to check for updates. Please try again later.'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _checkForUpdates(); // Retry the update check
//             },
//             child: const Text('Retry'),
//           ),
//         ],
//       );
//     },
//   );
// }

class CompanyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeNavigationController());
    Get.put(CurrentUserController());
    Get.put(MyVehiclesController());
    Get.put(FilterController());
    Get.put(CompanyHomeController());
    Get.put(SharedHomeController());
    Get.put(NotificationsController());
    Get.put(OnlineSocketController());
    Get.put(RefreshSocketController());
  }
}

class CustomerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeNavigationController());
    Get.put(CurrentUserController());
    Get.put(FilterController());
    Get.put(CustomerHomeController());
    Get.put(SharedHomeController());
    Get.put(NotificationsController());
    Get.put(OnlineSocketController());
    Get.put(RefreshSocketController());
  }
}

class DriverBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeNavigationController());
    Get.put(CurrentUserController());
    Get.put(FilterController());
    Get.put(DriverHomeController());
    Get.put(SharedHomeController());
    Get.put(NotificationsController());
    Get.put(OnlineSocketController());
    Get.put(RefreshSocketController());
  }
}
