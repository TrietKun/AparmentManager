import 'package:apartment_manager_user/models/user.dart';
import 'package:apartment_manager_user/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final User user = Get.find<User>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cài Đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Thông tin người dùng
            const Text(
              'Thông tin người dùng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(user.username.value, style: const TextStyle(fontSize: 18),),
              subtitle: Text('Email: ${user.email.value}'),
            ),
            const Divider(),

            // Cài đặt ứng dụng
            const Text(
              'Cài Đặt Ứng Dụng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Đổi mật khẩu'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
            ListTile(
              title: const Text('Thông báo'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Xử lý thông báo ở đây
              },
            ),
            ListTile(
              title: const Text('Đăng xuất'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Đổi Mật Khẩu'),
          content: CupertinoTextField(
            controller: passwordController,
            placeholder: "Nhập mật khẩu mới",
            obscureText: true,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Lưu'),
              onPressed: () {
                // Xử lý lưu mật khẩu mới ở đây
                print('Mật khẩu mới: ${passwordController.text}');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Xác nhận Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Đăng xuất'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) =>  const LoginPage()),
                  (Route<dynamic> route) =>
                      false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
