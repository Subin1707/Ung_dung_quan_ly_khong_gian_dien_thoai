import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ThongTinNhom extends StatefulWidget {
  const ThongTinNhom({super.key});

  @override
  State<ThongTinNhom> createState() => _ThongTinNhomState();
}

class _ThongTinNhomState extends State<ThongTinNhom> {
  late VideoPlayerController _bgController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _bgController = VideoPlayerController.asset("assets/video/nenthongtin.mp4");

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _bgController.initialize();
      _bgController
        ..setLooping(true)
        ..setVolume(0)
        ..play();

      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    } catch (e) {
      debugPrint("Video load error: $e");
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          /// ===== VIDEO BACKGROUND =====
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _bgController.value.size.width,
                height: _bgController.value.size.height,
                child: VideoPlayer(_bgController),
              ),
            ),
          ),

          /// Lớp làm tối video
          Container(color: Colors.black.withOpacity(0.5)),

          /// ===== NỘI DUNG =====
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// ===== LOGO (ẢNH) =====
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/hinh_anh/logo1.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        "BÀI TẬP LỚN CUỐI KỲ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "NHÓM 13",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber,
                        ),
                      ),

                      const Divider(
                        height: 30,
                        thickness: 1.2,
                        color: Colors.white70,
                      ),

                      _thongTinDong(
                        "Môn học",
                        "Lập trình cho thiết bị di động",
                      ),
                      _thongTinDong(
                        "Tên đề tài",
                        "Quản lý & cá nhân hóa không gian điện thoại",
                      ),

                      const SizedBox(height: 25),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Giảng viên hướng dẫn:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "TS. Nguyễn Xuân Quế",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Thành viên nhóm:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _thanhVienCard(
                            "assets/hinh_anh/quyen.jpg",
                            "Nguyễn Mạnh Quyền",
                            "23010198",
                          ),
                          _thanhVienCard(
                            "assets/hinh_anh/hoang.jpg",
                            "Phạm Văn Hoàng",
                            "23010245",
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      _thongTinDong("Năm thực hiện", "2025"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thongTinDong(String tieuDe, String noiDung) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$tieuDe:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(noiDung, style: const TextStyle(color: Colors.white70)),
          ),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "MSSV: $mssv",
          style: const TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }
}
