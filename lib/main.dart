import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF42A5F5),
          foregroundColor: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const ManHinhChinh(),
    ),
  );
}

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

void quayVeManHinhChinh(BuildContext context) {
  Navigator.popUntil(context, (route) {
    return route.isFirst;
  });
}

// ----------------------------------------------------
// 2. Màn Hình Chính - HOME (Water Tracker)
// ----------------------------------------------------

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({super.key});

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  // Biến trạng thái: Mục tiêu, Lượng đã uống và Thời gian nhắc nhở
  int _mucTieuHangNgay = 2500;
  int _soLuongNuocDaUong = 1200;
  String _thoiGianNhacNho = '08:00 - 22:00';

  // Hàm cập nhật Lượng nước đã uống
  void _themNuoc(int ml) {
    setState(() {
      _soLuongNuocDaUong += ml;
      if (_soLuongNuocDaUong > _mucTieuHangNgay) {
        _soLuongNuocDaUong = _mucTieuHangNgay;
      }
      _hienThiThongBao('Đã thêm $ml ml nước!');
    });
  }

  // Hàm cập nhật Mục tiêu hàng ngày
  void _capNhatMucTieu(int newGoal) {
    setState(() {
      _mucTieuHangNgay = newGoal;
      if (_soLuongNuocDaUong > _mucTieuHangNgay) {
        _soLuongNuocDaUong = _mucTieuHangNgay;
      }
    });
    _hienThiThongBao('Mục tiêu mới: $newGoal ml');
  }

  // Hàm cập nhật Thời gian nhắc nhở
  void _capNhatThoiGianNhacNho(String newTime) {
    setState(() {
      _thoiGianNhacNho = newTime;
    });
    _hienThiThongBao('Thời gian nhắc nhở mới: $newTime');
  }

  // Hàm hiển thị SnackBar
  void _hienThiThongBao(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán tiến độ
    // double progress = _soLuongNuocDaUong / _mucTieuHangNgay;
    // if (progress > 1.0) progress = 1.0;

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
            Text(
              'Mục tiêu: $_mucTieuHangNgay ml',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 30),

            // Vòng tròn tiến độ
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade100, width: 20),
              ),
              child: Center(
                child: Text(
                  '$_soLuongNuocDaUong / $_mucTieuHangNgay ml',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42A5F5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Nút Thêm 300ml
            FloatingActionButton.extended(
              onPressed: () {
                _themNuoc(300); // Gọi hàm cập nhật trạng thái
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
                // Truyền callback và các giá trị state qua ManHinhA
                hienThiManHinh(
                  context,
                  ManHinhA(
                    currentGoal: _mucTieuHangNgay,
                    onGoalUpdated: _capNhatMucTieu,
                    currentReminderTime: _thoiGianNhacNho,
                    onReminderTimeUpdated: _capNhatThoiGianNhacNho,
                  ),
                );
              },
              icon: const Icon(Icons.history, color: Colors.blueGrey),
              label: const Text(
                'Xem Lịch Sử Uống Nước',
                style: TextStyle(color: Colors.blueGrey),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 1,
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

// ----------------------------------------------------
// 3. Màn Hình A (History Screen)
// ----------------------------------------------------

class ManHinhA extends StatelessWidget {
  final int currentGoal;
  final Function(int) onGoalUpdated;
  final String currentReminderTime;
  final Function(String) onReminderTimeUpdated;

  const ManHinhA({
    super.key,
    required this.currentGoal,
    required this.onGoalUpdated,
    required this.currentReminderTime,
    required this.onReminderTimeUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📜 Lịch Sử Uống Nước')),
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
                // Truyền callback và current goal/reminder time vào ManHinhB
                hienThiManHinh(
                  context,
                  ManHinhB(
                    currentGoal: currentGoal,
                    onGoalUpdated: onGoalUpdated,
                    currentReminderTime: currentReminderTime,
                    onReminderTimeUpdated: onReminderTimeUpdated,
                  ),
                );
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

// ----------------------------------------------------
// 4. Màn Hình B (Settings Screen)
// ----------------------------------------------------

class ManHinhB extends StatelessWidget {
  final int currentGoal;
  final Function(int) onGoalUpdated;
  final String currentReminderTime;
  final Function(String) onReminderTimeUpdated;

  const ManHinhB({
    super.key,
    required this.currentGoal,
    required this.onGoalUpdated,
    required this.currentReminderTime,
    required this.onReminderTimeUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Cài Đặt & Thông Tin')),
      body: ListView(
        children: [
          // Mục tiêu hàng ngày - Dùng hàm onTap để chỉnh sửa
          _buildSettingsTile(
            'Mục tiêu hàng ngày',
            '$currentGoal ml',
            Icons.flag,
            () => _showGoalEditDialog(context),
          ),

          // Thời gian nhắc nhở - Dùng hàm onTap để chỉnh sửa
          _buildSettingsTile(
            'Thời gian nhắc nhở',
            currentReminderTime,
            Icons.alarm,
            () => _showReminderTimeEditDialog(context),
          ),
          _buildSettingsTile('Ngôn ngữ', 'Tiếng Việt', Icons.language),

          const Divider(),

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
  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon, [
    VoidCallback? onTap,
  ]) {
    return ListTile(
      leading: Icon(
        icon,
        color: onTap != null ? Colors.blue : Colors.grey.shade600,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      // Hiển thị icon edit nếu có onTap, ngược lại hiển thị mũi tên
      trailing: Icon(
        onTap != null ? Icons.edit : Icons.arrow_forward_ios,
        size: 16,
        color: onTap != null ? Colors.blue : Colors.grey,
      ),
      onTap: onTap,
    );
  }

  // Hộp thoại chỉnh sửa mục tiêu
  void _showGoalEditDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: currentGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đặt Mục Tiêu Mới'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: "Nhập mục tiêu (ml)",
              suffixText: 'ml',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                final newGoalString = controller.text;
                final newGoal = int.tryParse(newGoalString);

                if (newGoal != null && newGoal > 0) {
                  onGoalUpdated(newGoal);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mục tiêu không hợp lệ')),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // HỘP THOẠI MỚI: Chỉnh sửa thời gian nhắc nhở
  void _showReminderTimeEditDialog(BuildContext context) {
    // Sử dụng StatefulWidget bên trong AlertDialog để quản lý tạm thời TimeOfDay
    showDialog(
      context: context,
      builder: (context) {
        // Tách chuỗi hiện tại để lấy giờ bắt đầu và kết thúc
        List<String> parts = currentReminderTime.split(' - ');
        TimeOfDay startTime = TimeOfDay(
          hour: int.parse(parts[0].split(':')[0]),
          minute: int.parse(parts[0].split(':')[1]),
        );
        TimeOfDay endTime = TimeOfDay(
          hour: int.parse(parts[1].split(':')[0]),
          minute: int.parse(parts[1].split(':')[1]),
        );

        // Hàm format đơn giản về HH:mm (24h)
        String formatTime(TimeOfDay time) {
          final hour = time.hour.toString().padLeft(2, '0');
          final minute = time.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('⏰ Chỉnh Sửa Thời Gian Nhắc Nhở'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bắt đầu
                  ListTile(
                    title: const Text('Giờ Bắt Đầu'),
                    trailing: Text(
                      formatTime(startTime),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                      );
                      if (picked != null) {
                        setState(() {
                          startTime = picked;
                        });
                      }
                    },
                  ),
                  // Kết thúc
                  ListTile(
                    title: const Text('Giờ Kết Thúc'),
                    trailing: Text(
                      formatTime(endTime),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                      );
                      if (picked != null) {
                        setState(() {
                          endTime = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    // Kiểm tra logic thời gian (Bắt đầu không thể sau Kết thúc)
                    if (startTime.hour > endTime.hour ||
                        (startTime.hour == endTime.hour &&
                            startTime.minute >= endTime.minute)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Giờ bắt đầu phải trước giờ kết thúc!'),
                        ),
                      );
                      return;
                    }

                    String newReminderTime =
                        '${formatTime(startTime)} - ${formatTime(endTime)}';

                    onReminderTimeUpdated(newReminderTime); // GỌI CALLBACK
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Hiển thị hộp thoại Thông tin nhóm
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
                Text('• Thành viên 1: Đỗ Khắc Huy (Leader)'),
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
