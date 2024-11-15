import 'package:apartment_manager_user/controller/bill.controller.dart';
import 'package:apartment_manager_user/views/allbillpage.dart';
import 'package:apartment_manager_user/views/viewvnpay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  final BillController billController = Get.find();
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN');
  final formatDate = DateFormat('dd/MM/yyyy');

  final Map<int, bool> _isExpanded = {};

  @override
  Widget build(BuildContext context) {
    var bills = billController.bills;

    final List<int> months =
        bills.map((bill) => bill.date.value.month).toSet().toList();
    months.sort();
    // lấy ra bill tháng gần nhất
    final latestBill = bills.firstWhere(
      (bill) => bill.date.value.month == months.last,
      orElse: () => bills.first,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Tổng chi tiêu sáu tháng gần nhất',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200, // Chiều cao cho biểu đồ
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 80,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString().length > 6
                                          ? '${value.toInt() ~/ 1000000} triệu'
                                          : value.toInt().toString().length > 3
                                              ? '${value.toInt() ~/ 1000} nghìn'
                                              : value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    final reversedIndex =
                                        months.length - 1 - value.toInt();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '${months[reversedIndex]}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            //tooltip khi nhấn vào điểm trên biểu đồ
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (spot) => Colors.blue,
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((touchedSpot) {
                                    final bill = bills[touchedSpot.spotIndex];
                                    return LineTooltipItem(
                                      '${formatDate.format(bill.date.value)}: ${formatCurrency.format(bill.total.value)}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: bills.map((bill) {
                                  return FlSpot(
                                    bills.indexOf(bill).toDouble(),
                                    bill.total.value.toDouble(),
                                  );
                                }).toList(),
                                isCurved: true,
                                color: Colors.blue,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //thêm biểu đồ tròn, tiền điện, tiền nước, tiền phòng
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text('Tổng chi tiêu theo loại',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            )),
                      ),
                      const SizedBox(height: 12),
                      // Container để bao quanh PieChart
                      Center(
                        child: Container(
                          height: 200, // Chỉ định chiều cao
                          width: 200, // Chỉ định chiều rộng
                          decoration: BoxDecoration(
                            color: Colors.white, // Màu nền cho container
                            borderRadius:
                                BorderRadius.circular(100), // Để tạo hình tròn
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(2, 5), // Đổ bóng dưới
                              ),
                            ],
                          ),
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange,
                                      Colors.orange.shade200
                                    ],
                                  ),
                                  value: latestBill.electric.value.toDouble(),
                                  title: 'Điện',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.blue.shade200],
                                  ),
                                  value: latestBill.water.value.toDouble(),
                                  title: 'Nước',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green,
                                      Colors.green.shade200
                                    ],
                                  ),
                                  value: latestBill.price.value.toDouble(),
                                  title: 'Tổng',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              for (var index = 0; index < bills.length; index++)
                Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                            'Hóa đơn tháng ${formatDate.format(bills[index].date.value).split('/')[1]}/${formatDate.format(bills[index].date.value).split('/')[2]}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Số tiền: ${formatCurrency.format(bills[index].total.value)}'),
                            Text(
                              'Hạn nộp: ${formatDate.format(bills[index].date.value.add(const Duration(days: 30)))}',
                            ),
                          ],
                        ),
                        trailing: _isExpanded[index] == true
                            ? IconButton(
                                icon: const Icon(CupertinoIcons.arrow_up),
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[index] = false;
                                  });
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[index] =
                                        !(_isExpanded[index] ?? false);
                                  });
                                },
                              ),
                      ),
                      // Hiển thị phần chi tiết với hiệu ứng
                      AnimatedSize(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: FractionallySizedBox(
                          widthFactor: 0.95,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white, // Màu nền
                              boxShadow: _isExpanded[index] == true
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.5), // Màu bóng đổ
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: const Offset(
                                            0, 3), // Bóng đổ chìm xuống
                                      ),
                                    ]
                                  : [], // Khi không mở, không có bóng đổ
                              borderRadius: BorderRadius.circular(
                                  12), // Tùy chỉnh viền bo tròn
                            ),
                            // Chiều rộng 95%
                            width: double.infinity,
                            height: _isExpanded[index] == true
                                ? 195
                                : 0, // Chiều cao tùy chỉnh
                            child: _isExpanded[index] == true
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isExpanded[index] = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, top: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Chi tiết hóa đơn',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Tiền điện:'),
                                              Text(formatCurrency.format(
                                                  bills[index].electric.value)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Tiền nước:'),
                                              Text(formatCurrency.format(
                                                  bills[index].water.value)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Tiền phòng:'),
                                              Text(formatCurrency.format(
                                                  bills[index].price.value)),
                                            ],
                                          ),

                                          //nút thanh toán
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: FractionallySizedBox(
                                                widthFactor:
                                                    0.95, // 80% chiều rộng của phần tử ngoài
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade100),
                                                  onPressed: () {
                                                    // navigate to payment page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewVnPay(),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Thanh toán',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : null, // Nếu không mở, trả về null
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              //nút xem tất cả hóa đơn
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: FractionallySizedBox(
                    widthFactor:
                        0.9, // Chiều rộng 90% của phần tử ngoài, tinh tế hơn
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                            .shade50, // Màu nền rất nhạt, tạo sự nhẹ nhàng
                        padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20), // Padding hợp lý, không quá dày
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Bo góc vừa phải, không quá tròn
                          side: BorderSide(
                              color: Colors.green.shade300,
                              width: 1), // Viền mảnh, nhẹ nhàng
                        ),
                        elevation: 2, // Độ nổi bóng vừa phải, tránh quá nặng nề
                        shadowColor: Colors.green.shade100, // Bóng đổ nhẹ nhàng
                      ),
                      onPressed: () {
                        // Xử lý khi bấm nút
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  const Allbillpage()),
                          );
                      },
                      child: const Text(
                        'Xem tất cả hóa đơn',
                        style: TextStyle(
                          fontSize: 16, // Giữ kích thước vừa phải
                          color: Colors
                              .green, // Màu chữ xanh lá để đồng bộ màu sắc
                          fontWeight: FontWeight
                              .w600, // Chữ không quá đậm để giữ sự thanh thoát
                          letterSpacing: 1, // Giữ khoảng cách chữ vừa phải
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
