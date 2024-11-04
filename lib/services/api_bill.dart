import 'package:apartment_manager_user/models/bills.dart';
import 'package:dio/dio.dart';

class ApiBill {
    final Dio dio = Dio();
    late final List<Bill> bills;

    Future<List<Bill>> getBillById(String id, int page, int limit) async {
        try {
            Response response = await dio.get('http://192.168.100.161:5001/api/bill/get-bills-by-apartment/$id/$page/$limit');
            if (response.statusCode == 200) {
                final data = response.data['data']['data'];
                List<Bill> bills = [];
                for (var item in data) {
                    Bill bill = Bill(
                        price: item['price'] ?? 0.0,
                        electric: item['electric'] ?? 0.0,
                        water: item['water'] ?? 0.0,
                        total: item['total'] ?? 0.0,
                        date: DateTime.parse(item['date'] ?? ''),
                    );
                    bills.add(bill);
                }
                print(bills);
                return bills;
            } else {
                throw Exception('Lấy thông tin hóa đơn thất bại: ${response.data['message']}');
            }
        }  catch (e) {
            throw Exception('Lấy thông tin hóa đơn thất bại: ${e}');
        }
    }
}