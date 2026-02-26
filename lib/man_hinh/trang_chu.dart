import 'package:flutter/material.dart';
import 'khong_gian_lam_viec.dart';
import 'khong_gian_thu_gian.dart';
import 'khong_gian_ca_nhan.dart';
import 'thong_tin_nhom.dart';

class TrangChu extends StatelessWidget {
  const TrangChu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ứng dụng Quản lý Không gian",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            children: [
              _buildCard(
                context,
                icon: Icons.work,
                title: "Làm việc",
                color: Colors.blue,
                screen: const KhongGianLamViec(),
              ),
              _buildCard(
                context,
                icon: Icons.self_improvement,
                title: "Thư giãn",
                color: Colors.green,
                screen: const KhongGianThuGian(),
              ),
              _buildCard(
                context,
                icon: Icons.person,
                title: "Cá nhân",
                color: Colors.orange,
                screen: const KhongGianCaNhan(),
              ),
              _buildCard(
                context,
                icon: Icons.info_outline,
                title: "Thông tin nhóm",
                color: Colors.purple,
                screen: const ThongTinNhom(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Widget screen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Vòng tròn icon
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, size: 40, color: color),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
