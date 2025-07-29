import 'package:get/get.dart';
import 'package:shipment/models/faq_model.dart';

import '../services/remote_services.dart';

class FaqController extends GetxController {
  @override
  void onInit() {
    getFAQs();
    super.onInit();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<FaqModel> faqs = [];

  void getFAQs() async {
    toggleLoading(true);
    List<FaqModel> newItems = await RemoteServices.fetchFAQs() ?? [];
    faqs.addAll(newItems);
    faqs.sort((a, b) => a.order.compareTo(b.order));
    toggleLoading(false);
  }

  Future refreshFAQ() async {
    faqs.clear();
    getFAQs();
  }
}
