
import 'package:get/get.dart';

class Aparment extends GetxController {
  final RxString name = ''.obs;
  final RxInt area = 0.obs;
  final RxInt rooms = 0.obs;
  final RxString status = ''.obs;

  Aparment({
    required String name,
    required int area,
    required int rooms,
    required String status,
  }) {
    this.name.value = name;
    this.area.value = area;
    this.rooms.value = rooms;
    this.status.value = status;
  }

  @override
  String toString() {
    return 'Apartment{name: ${name.value}, area: ${area.value}, rooms: ${rooms.value}, status: ${status.value}}';
  }
}