import 'package:apartment_manager_user/models/user.dart';
import 'package:dio/dio.dart';

class ApiAuth {
  final Dio _dio = Dio();
  late final User user;

  Future<User> login(String username, String password) async {
  try {
    // Gọi API login
    Response response = await _dio.post('http://localhost:5001/api/auth/login', data: {
      'username': 'resieasy.iuh@gmail.com',
      'password': 'admin', 
    });

    if (response.statusCode == 200) {
      // Giả định rằng phản hồi trả về thông tin người dùng trong trường 'data'
      final data = response.data['user']; // Thay đổi này tùy thuộc vào cấu trúc phản hồi của bạn

      // Tạo đối tượng User từ dữ liệu phản hồi
      User user = User(
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        dob: DateTime.parse(data['dob'] ?? ''),
        gender: data['gender'] ?? '',
        address: data['address'] ?? '',
        apartment: List<String>.from(data['apartments'] ?? []),
        username: data['username'] ?? '',
        password: password,
      );

      // Cập nhật biến user
      this.user = user;
      return user; // Trả về đối tượng user
    } else {
      throw Exception('Đăng nhập thất bại: ${response.data['message']}');
    }
  } on DioException catch (e) {
    throw Exception('Đăng nhập thất bại: ${e.message}');
  }
}


//get user by email /get-user-by-email/:email
Future<User> getUserByEmail(String email) async {
  try {
    // Gọi API lấy thông tin người dùng theo email
    Response response = await _dio.get('http://localhost:5001/api/user/get-user-by-email/$email');

    if (response.statusCode == 200) {
      // Giả định rằng phản hồi trả về thông tin người dùng trong trường 'data'
      final data = response.data['user']; // Thay đổi này tùy thuộc vào cấu trúc phản hồi của bạn

      // Tạo đối tượng User từ dữ liệu phản hồi
      User user = User(
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        dob: DateTime.parse(data['dob'] ?? ''),
        gender: data['gender'] ?? '',
        address: data['address'] ?? '',
        apartment: List<String>.from(data['apartment'] ?? []),
        username: data['username'] ?? '',
        password: data['password'] ?? '',
      );

      // Cập nhật biến user
      this.user = user;
      return user; // Trả về đối tượng user

    } else {
      throw Exception('Lấy thông tin người dùng thất bại: ${response.data['message']}');
    }
  } on DioException catch (e) {
    throw Exception('Lấy thông tin người dùng thất bại: ${e.message}');
  }
}

}
