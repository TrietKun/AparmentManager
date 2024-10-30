import 'package:get/get.dart';

class Bill extends GetxController{
  final RxInt price = 0.obs;
  final RxInt electric = 0.obs;
  final RxInt water = 0.obs;
  final RxInt total = 0.obs;
  final Rx<DateTime> date = DateTime.now().obs;

  Bill({
    required int price,
    required int electric,
    required int water,
    required int total,
    required DateTime date,
  }) {
    this.price.value = price;
    this.electric.value = electric;
    this.water.value = water;
    this.total.value = total;
    this.date.value = date;
  }

  @override
  String toString() {
    return 'Bill{price: ${price.value}, electric: ${electric.value}, water: ${water.value}, total: ${total.value}, date: ${date.value}}';
  }
}