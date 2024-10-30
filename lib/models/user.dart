import 'package:get/get.dart';

class User extends GetxController {
  // Make fields observable
  final RxString username = ''.obs;
  final RxString password = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final Rx<DateTime> dob = DateTime.now().obs;
  final RxString gender = ''.obs;
  final RxString address = ''.obs;
  final RxList<String> apartment = <String>[].obs;

  User({
    required String email,
    required String phone,
    required DateTime dob,
    required String gender,
    required String address,
    required List<String> apartment,
    required String username,
    required String password,
  }) {
    this.email.value = email;
    this.phone.value = phone;
    this.dob.value = dob;
    this.gender.value = gender;
    this.address.value = address;
    for (var element in apartment) {
      this.apartment.add(element);
    }
    this.username.value = username;
    this.password.value = password;
  }

  // toString method
  @override
  String toString() {
    return 'User{username: ${username.value}, password: ${password.value}, email: ${email.value}, phone: ${phone.value}, dob: ${dob.value}, gender: ${gender.value}, address: ${address.value}, apartment: ${apartment.join(', ')}}';
  }
}
