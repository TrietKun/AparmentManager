import 'package:apartment_manager_user/models/aparment.dart';
import 'package:dio/dio.dart';

class ApiAparment {
  final Dio _dio = Dio();
  late final Aparment aparment;

  //get aparment by id
  Future<Aparment> getAparmentById(String id) async {
    try {
      // Gọi API lấy thông tin căn hộ theo id
      Response response = await _dio.get('http://localhost:5001/api/apartment/get-detail-apartment/$id');

      if (response.statusCode == 200) {
        // Giả định rằng phản hồi trả về thông tin căn hộ trong trường 'data'
        final data = response.data; // Thay đổi này tùy thuộc vào cấu trúc phản hồi của bạn

        // Tạo đối tượng Aparment từ dữ liệu phản hồi
        Aparment aparment = Aparment(
          name: data['name'] ?? '',
          area: data['area'] ?? 0,
          rooms: data['rooms'] ?? 0,
          status: data['status'] ?? '',
        );
        // Cập nhật biến aparment
        this.aparment = aparment;
        return aparment; // Trả về đối tượng aparment
      } else {
        throw Exception('Lấy thông tin căn hộ thất bại: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('Lấy thông tin căn hộ thất bại: ${e.message}');
    }
  }
}
