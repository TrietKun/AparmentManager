import 'package:apartment_manager_user/models/aparment.dart';
import 'package:apartment_manager_user/models/user.dart';
import 'package:flutter/material.dart';
import 'package:apartment_manager_user/views/billpage.dart';
import 'package:apartment_manager_user/views/settingpage.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _widgetOptions = [
    HomeContent(),
    const BillPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFFE3F2FD), // Màu nền dịu mắt
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Hóa Đơn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài Đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  HomeContent({super.key});
  //lấy data user từ Getx
  final User user = Get.find<User>();
  final Aparment aparment = Get.find<Aparment>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(  
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(),
              const SizedBox(height: 20),
              _buildUserInfoCard(),
              const SizedBox(height: 20),
              _buildImportantInfoCard(),
              const SizedBox(height: 20),
              _buildServiceInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFA3D8FF), Color(0xFFB8EBAA)], // Sử dụng tông màu pastel
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Apartment Management',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Thay đổi thành màu tối hơn
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Track your apartment and user info with ease.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54, // Thay đổi thành màu tối hơn
          ),
        ),
      ],
    ),
  );
}


  Widget _buildUserInfoCard() {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 8, // Tăng độ đổ bóng
    shadowColor: Colors.black26, // Màu đổ bóng nhẹ hơn
    color: Colors.white, // Màu nền thẻ
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://avatar.iran.liara.run/public'),
          ),
          const SizedBox(width: 16),
          Expanded( // Giúp phần này chiếm toàn bộ không gian còn lại
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Màu chữ đậm hơn
                  ),
                  overflow: TextOverflow.ellipsis, // Cắt ngắn văn bản nếu quá dài
                  maxLines: 1, // Chỉ hiển thị 1 dòng
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.blue), // Biểu tượng email
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        user.email.value,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700], // Màu chữ
                        ),
                        overflow: TextOverflow.ellipsis, // Cắt ngắn văn bản nếu quá dài
                        maxLines: 1, // Chỉ hiển thị 1 dòng
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Khoảng cách giữa các dòng
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green), // Biểu tượng điện thoại
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        user.phone.value,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700], // Màu chữ
                        ),
                        overflow: TextOverflow.ellipsis, // Cắt ngắn văn bản nếu quá dài
                        maxLines: 1, // Chỉ hiển thị 1 dòng
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildServiceInfoCard() {
  return GestureDetector(
    onTap: () {
      // Thêm hành động khi nhấn vào thẻ nếu cần
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500), // Thêm hiệu ứng animation
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.greenAccent, Colors.teal], // Gradient màu cho thẻ
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20), // Góc bo tròn
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Đổ bóng đậm hơn
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tiêu đề thẻ
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: const Text(
              'Các dịch vụ đang sử dụng',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              shrinkWrap: true, // Để GridView co giãn vừa với nội dung
              crossAxisCount: 2, // Số cột là 2
              crossAxisSpacing: 10, // Khoảng cách giữa các cột
              mainAxisSpacing: 10, // Khoảng cách giữa các hàng
              children: [
                _buildServiceBox('Điện', '3500 VNĐ/1KW', Icons.flash_on),
                _buildServiceBox('Nước', '4000 VNĐ/m³', Icons.opacity),
                _buildServiceBox('Internet', '300.000 VNĐ', Icons.wifi),
                _buildServiceBox('Hồ bơi', '300.000 VNĐ', Icons.pool),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildServiceBox(String serviceName, String serviceCost, IconData icon) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2), // Màu nền mờ
      borderRadius: BorderRadius.circular(10), // Góc bo tròn
      boxShadow: const [
        BoxShadow(
          color: Colors.black26, // Đổ bóng nhẹ
          blurRadius: 5,
          offset: Offset(0, 5),
        ),
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Canh giữa nội dung trong ô
      children: [
        //icon
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        Text(
          serviceName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8), // Khoảng cách giữa tên và giá
        Text(
          serviceCost,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}


Widget _buildImportantInfoCard() {
  return GestureDetector(
    onTap: () {
      // Bạn có thể thêm hành động khi nhấn vào thẻ, nếu cần
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500), // Animation mượt mà hơn
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Đổ bóng đậm hơn
            blurRadius: 15, // Bán kính làm mờ lớn hơn
            offset: Offset(0, 10), // Vị trí của bóng
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin căn hộ',
              style: TextStyle(
                fontSize: 22, // Kích cỡ lớn hơn
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu sắc nổi bật
              ),
            ),
            _buildDetailRow('Căn hộ:', aparment.name.value, Colors.white),
            _buildDetailRow('Diện tích:', '${aparment.area.value} m²', Colors.white),
            _buildDetailRow('Số phòng:', '${aparment.rooms.value}', Colors.white),
            _buildDetailRow('Trạng thái:', aparment.status.value == 'rented' ? 'Đang thuê' : 'Chưa thuê', Colors.white),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDetailRow(String label, String value, Color textColor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0), // Thêm padding giữa các hàng
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(0.8), // Màu nhạt hơn cho nhãn
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor, // Màu nổi bật hơn cho giá trị
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}


}
