import 'package:flutter/material.dart';

class ThongTinNhom extends StatelessWidget {
  const ThongTinNhom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin nhóm"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ảnh đại diện nhóm (Asset)
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.asset(
                "assets/hinh_anh/avatar.png",
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "BÀI TẬP LỚN CUỐI KỲ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            _thongTinDong("Môn học:", "Lập trình cho thiết bị di động"),
            _thongTinDong(
              "Tên đề tài:",
              "Quản lý và cá nhân hóa không gian điện thoại",
            ),
            _thongTinDong("Sinh viên:", "Nguyễn Mạnh Quyền"),
            _thongTinDong("GVHD:", "Nguyễn Xuân Quế"),
            _thongTinDong("Năm:", "2025"),
          ],
        ),
      ),
    );
  }

  Widget _thongTinDong(String tieuDe, String noiDung) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              tieuDe,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(flex: 5, child: Text(noiDung)),
        ],
      ),
    );
  }
}
