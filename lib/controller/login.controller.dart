import 'package:apartment_manager_user/controller/bill.controller.dart';
import 'package:apartment_manager_user/models/aparment.dart';
import 'package:apartment_manager_user/models/bills.dart';
import 'package:apartment_manager_user/models/user.dart';
import 'package:apartment_manager_user/services/api_aparment.dart';
import 'package:apartment_manager_user/services/api_bill.dart';
import 'package:apartment_manager_user/views/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../services/api_auth.dart';

class LoginController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final BuildContext context;
  final ApiAuth apiAuth = ApiAuth();
  final ApiAparment apiAparment = ApiAparment();
  final ApiBill apiBill = ApiBill();
  final BillController billController = Get.put(BillController());
  User? user;
  Aparment? aparment;
  List<Bill>? bills;
  final LocalAuthentication auth = LocalAuthentication();

  LoginController({required this.context});
  
  

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Xin vui lòng xác thực bằng Face ID hoặc vân tay để đăng nhập',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (authenticated) {
        loginbyemail();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    if (!canCheckBiometrics) {
      print("Thiết bị không hỗ trợ xác thực sinh trắc học.");
    }
  }

  Future<void> getAvailableBiometrics() async {
    try {
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      print(availableBiometrics);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void login() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      // Hiển thị dialog với biểu tượng progress khi bắt đầu đăng nhập
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return const CupertinoAlertDialog(
            title: Text('Đang đăng nhập...'),
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(radius: 15),
            ),
          );
        },
      );

      user = await apiAuth.login(username, password);
      aparment = await apiAparment.getAparmentById(user!.apartment[0]);
      // bills = (await apiBill.getBillById(user!.apartment[0])) as List<Bill>?;
      // bills = await apiBill.getBillById('66c6d6539b7b84b721c91a9f');
      await billController.fetchBills('66c6d6539b7b84b721c91a9f', 1, 6);
      Get.put<List<Bill>>(billController.bills);
      Get.put<Aparment>(aparment!);
      Get.put<User>(user!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print(e);
      Navigator.of(context).pop(); 
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Đăng nhập thất bại'),
            content: const Text('Sai tên đăng nhập hoặc mật khẩu'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void loginbyemail(){
    final String username = usernameController.text;
    try {
      // Hiển thị dialog với biểu tượng progress khi bắt đầu đăng nhập
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return const CupertinoAlertDialog(
            title: Text('Đang đăng nhập...'),
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(radius: 15),
            ),
          );
        },
      );

      user = apiAuth.getUserByEmail(username) as User?;
      //lưu thông tin user vào Getx
      Get.put<User>(user!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      Navigator.of(context).pop(); 
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Đăng nhập thất bại'),
            content: Text(e.toString()),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void setUsername(String value) {
    usernameController.text = value;
  }

  void setPassword(String value) {
    passwordController.text = value;
  }
}
