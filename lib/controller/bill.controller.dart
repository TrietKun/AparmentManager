import 'package:get/get.dart';
import 'package:apartment_manager_user/models/bills.dart';
import 'package:apartment_manager_user/services/api_bill.dart';

class BillController extends GetxController {
    var bills = <Bill>[].obs; // Observable list to store bills
    final ApiBill apiBill = ApiBill();

  get isLoading => null;
    Future<void> fetchBills(String id, int page, int limit) async {
        try {
            List<Bill> fetchedBills = await apiBill.getBillById(id, page, limit);
            bills.assignAll(fetchedBills); // Update the observable list
        } catch (e) {
            Get.snackbar('Error', e.toString()); // Show error message
        }
    }
}
