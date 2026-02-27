import 'package:flutter/material.dart';

class ThongTinNhom extends StatelessWidget {
  const ThongTinNhom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin nhóm"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Ảnh đại diện nhóm
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "NHÓM 13",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const Divider(height: 30, thickness: 1.2),

                  _thongTinDong("Môn học", "Lập trình cho thiết bị di động"),
                  _thongTinDong(
                    "Tên đề tài",
                    "Quản lý & cá nhân hóa không gian điện thoại",
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Thành viên nhóm:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// 2 thành viên hiển thị ngang
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _thanhVienCard(
                        "assets/hinh_anh/quyen.png",
                        "Nguyễn Mạnh Quyền",
                        "23010198",
                      ),
                      _thanhVienCard(
                        "assets/hinh_anh/hoang.png",
                        "Phạm Văn Hoàng",
                        "23010245",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _thongTinDong("GVHD", "Nguyễn Xuân Quế"),
                  _thongTinDong("Năm thực hiện", "2025"),
                ],
              ),
            ),
          ),
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
              "$tieuDe:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 5, child: Text(noiDung)),
        ],
      ),
    );
  }

  Widget _thanhVienCard(String imagePath, String ten, String mssv) {
    return Column(
      children: [
        CircleAvatar(radius: 45, backgroundImage: AssetImage(imagePath)),
        const SizedBox(height: 8),
        Text(
          ten,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Text(
          "MSSV: $mssv",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}
