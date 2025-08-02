import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:shipment/models/about_us_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/remote_services.dart';

class AboutUsController extends GetxController {
  @override
  void onInit() {
    getAboutUsInfo();
    super.onInit();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  AboutUsModel? aboutUsInfo;

  Future<void> getAboutUsInfo() async {
    if (isLoading) return;
    toggleLoading(true);
    aboutUsInfo = await RemoteServices.fetchAboutUSInfo();
    toggleLoading(false);
  }

  Future<void> callPhone(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res != true) {
      print("failed");
    }
  }

  void openWhatsApp(String phoneNumber) async {
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '963${phoneNumber.substring(1)}';
    }
    final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      // Handle the error
      print("WhatsApp not installed or cannot launch URL");
    }
  }

  String cleanUrl(String url) {
    if (url.startsWith('https://')) {
      return url.replaceFirst('https://', '');
    }
    return url;
  }

  void launchWebsite() async {
    String website = cleanUrl(aboutUsInfo!.website);
    final url = Uri.parse("https://$website");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // opens in browser
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'kamion@gmail.com',
    );
    launchUrl(emailUri);
  }
}
