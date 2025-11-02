import 'package:flutter/material.dart';

void main() {
  // Thay thế MaterialApp cơ bản bằng widget bao bọc cho giao diện đẹp hơn
  runApp(
    MaterialApp(
      // Định nghĩa theme cơ bản để nhất quán
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF42A5F5), // Màu xanh dương nhạt
          foregroundColor: Colors.white,
        ),
        // Sử dụng một font chữ rõ ràng và dễ đọc
        fontFamily: 'Roboto',
      ),
      home: const ManHinhChinh(), // Đổi tên class cho chuẩn Flutter
    ),
  );
}

// Hàm điều hướng tới màn hình mới (push)
void hienThiManHinh(BuildContext context, Widget manHinh) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return manHinh;
      },
    ),
  );
}

// Hàm quay về màn hình trước (pop)
void quayVeManHinhTruoc(BuildContext context) {
  Navigator.pop(context);
}

// Hàm quay về màn hình chính (popUntil isFirst)
void quayVeManHinhChinh(BuildContext context) {
  Navigator.popUntil(context, (route) {
    return route.isFirst;
  });
}

// ----------------------------------------------------
// 2. Màn Hình Chính - HOME (Theo dõi lượng nước)
// ----------------------------------------------------

class ManHinhChinh extends StatelessWidget {
  const ManHinhChinh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💧 Water Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mục tiêu: 2500 ml',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 30),

            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade100, width: 20),
              ),
              child: const Center(
                child: Text(
                  '1200 / 2500 ml',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42A5F5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            FloatingActionButton.extended(
              onPressed: () {
                // Giả lập thêm 300ml
                // Trong thực tế sẽ cần StatefulWidget để cập nhật số liệu
              },
              label: const Text('Thêm 300 ml'),
              icon: const Icon(Icons.add_circle_outline),
              backgroundColor: const Color(0xFF42A5F5),
              foregroundColor: Colors.white,
              extendedPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),

            const SizedBox(height: 40),

            // Nút điều hướng tới màn hình Lịch sử (History Screen)
            ElevatedButton.icon(
              onPressed: () {
                hienThiManHinh(context, const ManHinhA());
              },
              icon: const Icon(Icons.history, color: Colors.blueGrey),
              label: const Text(
                'Xem Lịch Sử Uống Nước',
                style: TextStyle(color: Colors.blueGrey),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 1, // Tạo chút đổ bóng nhẹ
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManHinhA extends StatelessWidget {
  const ManHinhA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📜 Lịch Sử Uống Nước'),
        // Nút Back tự động hiển thị, không cần thêm quay_ve_man_hinh_truoc
      ),
      body: Column(
        children: [
          // Thẻ chứa thông tin thống kê chung
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Ngày liên tục',
                    '7',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'Tổng ml',
                    '8400',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),

          // Danh sách các mục lịch sử
          Expanded(
            child: ListView(
              children: [
                _buildHistoryTile(
                  '20:30 - Hôm nay',
                  '300 ml',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildHistoryTile(
                  '18:00 - Hôm nay',
                  '500 ml',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildHistoryTile(
                  '08:00 - Hôm qua',
                  '400 ml',
                  Icons.water_drop,
                  Colors.blue,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                hienThiManHinh(context, const ManHinhB());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text(
                'Tới màn hình Cài đặt',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget phụ trợ cho mục thống kê
  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // Widget phụ trợ cho mục lịch sử
  Widget _buildHistoryTile(
    String time,
    String amount,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(time),
      trailing: Text(
        amount,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ManHinhB extends StatelessWidget {
  const ManHinhB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Cài Đặt & Thông Tin')),
      body: ListView(
        children: [
          _buildSettingsTile('Mục tiêu hàng ngày', '2500 ml', Icons.flag),
          _buildSettingsTile(
            'Thời gian nhắc nhở',
            '08:00 - 22:00',
            Icons.alarm,
          ),
          _buildSettingsTile('Ngôn ngữ', 'Tiếng Việt', Icons.language),

          const Divider(),

          // Yêu cầu "Trang thông tin của nhóm"
          ListTile(
            leading: const Icon(Icons.people, color: Colors.pink),
            title: const Text(
              'Thông tin về Nhóm Phát Triển',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          const Divider(),

          // Nút Về Màn Hình Chính
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                quayVeManHinhChinh(context);
              },
              icon: const Icon(Icons.home, color: Colors.white),
              label: const Text(
                'Quay Về Trang Chủ',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget phụ trợ cho mục cài đặt
  Widget _buildSettingsTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Hành động khi nhấn vào cài đặt
      },
    );
  }

  // Hiển thị hộp thoại Thông tin nhóm (đáp ứng yêu cầu)
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '💖 Về Nhóm DEV',
            style: TextStyle(color: Colors.blue),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ứng dụng "Water Tracker" được phát triển bởi:'),
                SizedBox(height: 10),
                Text('• Thành viên 1:Đỗ Khắc Huy(Leader)'),

                SizedBox(height: 10),
                Text('Phiên bản: 1.0.0'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng'),
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
