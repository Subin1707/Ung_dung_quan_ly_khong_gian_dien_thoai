import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'khong_gian_lam_viec.dart';
import 'khong_gian_thu_gian.dart';
import 'khong_gian_ca_nhan.dart';
import 'thong_tin_nhom.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key});

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/video/nentrangchu.mp4")
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0); // tắt âm thanh
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🎬 Video nền
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),

          // Lớp phủ mờ để dễ nhìn chữ
          Container(color: Colors.black.withOpacity(0.4)),

          // Nội dung chính
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Text(
                  "Ứng dụng Quản lý Không gian",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Expanded(
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
              ],
            ),
          ),
        ],
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
          color: Colors.white.withOpacity(0.85),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
