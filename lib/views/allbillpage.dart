import 'package:apartment_manager_user/controller/allbill.controller.dart';
import 'package:apartment_manager_user/controller/bill.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Allbillpage extends StatefulWidget {
  const Allbillpage({super.key});

  @override
  State<Allbillpage> createState() => _AllbillpageState();
}

class _AllbillpageState extends State<Allbillpage> {
  final BillController billController = Get.find();
  final Allbillcontroller allbillcontroller = Get.put(Allbillcontroller());
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN');
  final formatDate = DateFormat('dd/MM/yyyy');

  final Map<int, bool> _isExpanded = {};
  bool isLoadingMore = false; // Trạng thái cho việc tải thêm

  @override
  void initState() {
    super.initState();
    allbillcontroller.fetchAllBills('66c6d6539b7b84b721c91a9f', 6);
  }

  @override
  Widget build(BuildContext context) {
    final bills = allbillcontroller.bills;

    return Scaffold(
      appBar: AppBar(title: const Text('Tất cả hóa đơn')),
      body: Obx(() {
        if (bills.isEmpty) {
          return const Center(child: Text('Không có hóa đơn nào'));
        } else {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoadingMore) {
                setState(() {
                  isLoadingMore = true; // Đánh dấu đang tải thêm
                });
                allbillcontroller.loadMoreBills('66c6d6539b7b84b721c91a9f', 6).then((_) {
                  setState(() {
                    isLoadingMore = false; // Kết thúc quá trình tải
                  });
                });
              }
              return true;
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Hóa đơn tháng ${formatDate.format(bills[index].date.value).split('/')[1]}/${formatDate.format(bills[index].date.value).split('/')[2]}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Số tiền: ${formatCurrency.format(bills[index].total.value)}'),
                                  Text(
                                    'Hạn nộp: ${formatDate.format(bills[index].date.value.add(const Duration(days: 30)))}',
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  _isExpanded[index] == true ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[index] = !(_isExpanded[index] ?? false);
                                  });
                                },
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: _isExpanded[index] == true
                                  ? Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Tiền điện:'),
                                              Text(formatCurrency.format(bills[index].electric.value)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Tiền nước:'),
                                              Text(formatCurrency.format(bills[index].water.value)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Tiền phòng:'),
                                              Text(formatCurrency.format(bills[index].price.value)),
                                            ],
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: FractionallySizedBox(
                                                widthFactor: 0.95,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green.shade100,
                                                  ),
                                                  onPressed: () {
                                                    // Điều hướng đến trang thanh toán
                                                  },
                                                  child: const Text(
                                                    'Đã thanh toán',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Hiển thị CircularProgressIndicator khi đang tải thêm
                if (isLoadingMore) 
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        }
      }),
    );
  }
}
