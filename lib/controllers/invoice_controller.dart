import 'package:get/get.dart';
import 'package:shipment/models/invoice_model.dart';
import '../services/remote_services.dart';

class InvoiceController extends GetxController {
  @override
  onInit() async {
    getInvoices();
    super.onInit();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<InvoiceModel> invoices = [];

  void getInvoices() async {
    //todo(later): tell backend to implement pagination if necessary
    toggleLoading(true);
    List<InvoiceModel> newItems = await RemoteServices.fetchInvoices() ?? [];
    invoices.addAll(newItems);
    toggleLoading(false);
  }

  Future refreshBankDetails() async {
    invoices.clear();
    getInvoices();
  }
}
