import 'package:apartment_manager_user/models/bills.dart';
import 'package:apartment_manager_user/services/api_bill.dart';
import 'package:get/get.dart';

class Allbillcontroller extends GetxController {
  late RxList<Bill> bills = <Bill>[].obs;
  final ApiBill apiBill = ApiBill();
  var page = 1;

  var isLoading = false.obs; // Observable for loading state
  var hasFetchedBills = false; // Kiểm tra xem đã tải hóa đơn chưa
  final Set<int> loadedPages = {}; // Set để theo dõi các trang đã tải

  // Fetch bills from the API
  Future<void> fetchAllBills(String id, int limit) async {
    if (hasFetchedBills) return; // Nếu đã tải hóa đơn thì không làm gì cả

    try {
      isLoading(true); // Bắt đầu tải
      List<Bill> fetchedBills = await apiBill.getBillById(id, page, limit);
      bills.assignAll(fetchedBills); // Cập nhật danh sách bills
      loadedPages.add(page); // Đánh dấu trang này đã được tải
      page++; // Tăng số trang lên 1
      hasFetchedBills = true; // Đánh dấu là đã tải hóa đơn
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString()); // Hiển thị thông báo lỗi
    } finally {
      isLoading(false); // Kết thúc tải
    }
  }

  // Load more bills
  Future<void> loadMoreBills(String id, int limit) async {
    if (loadedPages.contains(page)) return; // Ngăn tải lại trang đã được tải

    try {
      isLoading(true); // Bắt đầu tải
      List<Bill> fetchedBills = await apiBill.getBillById(id, page, limit);
      if (fetchedBills.isNotEmpty) {
        bills.addAll(fetchedBills); // Cập nhật danh sách bills
        loadedPages.add(page); // Đánh dấu trang này đã được tải
        page++; // Tăng số trang lên 1
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString()); // Hiển thị thông báo lỗi
    } finally {
      isLoading(false); // Kết thúc tải
    }
  }
}

