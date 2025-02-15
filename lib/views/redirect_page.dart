import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shipment/views/company_home_view.dart';
import 'package:shipment/views/customer_home_view.dart';
import 'package:shipment/views/driver_home_view.dart';
import 'package:shipment/views/login_view.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    // Simulate a loading delay (e.g., 2 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Get the current app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print(currentVersion);

    // Make an API request to check for updates
    // final response = await http.get(
    //   Uri.parse('https://your-server.com/check-update?current_version=$currentVersion'),
    // );

    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   // bool updateRequired = data['update_required'];
    //   // String latestVersion = data['latest_version'];
    //   // String downloadUrl = data['download_url'];
    //
    //   if (updateRequired) {
    //     _showUpdateDialog(latestVersion, downloadUrl);
    //   } else {
    //     // No update required, proceed to the app
    _navigateToApp();
    //   }
    // } else {
    //   _showErrorDialog();
    // }

    setState(() {
      _isLoading = false;
    });
  }

  void _showUpdateDialog(String latestVersion, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Required'),
          content: Text('A new version ($latestVersion) is available. Please update to continue.'),
          actions: [
            TextButton(
              onPressed: () async {
                // Open the download URL in the browser
                if (await canLaunchUrl(Uri.parse(downloadUrl))) {
                  await launchUrl(Uri.parse(downloadUrl));
                } else {
                  // Handle error (e.g., show a message)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch the download URL.')),
                  );
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to check for updates. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _checkForUpdates(); // Retry the update check
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToApp() {
    GetStorage getStorage = GetStorage();
    Get.offAll(
      () => !getStorage.hasData("token")
          ? const LoginView()
          : getStorage.read("role") == "driver" || getStorage.read("role") == "company_employee"
              ? const DriverHomeView()
              : getStorage.read("role") == "customer"
                  ? const CustomerHomeView()
                  : getStorage.read("role") == "company"
                      ? const CompanyHomeView()
                      : const Placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Lottie.asset("assets/animations/simple truck.json") // Show loading indicator
            : const Text('Checking for updates...'),
      ),
    );
  }
}
