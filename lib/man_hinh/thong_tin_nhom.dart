import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ThongTinNhom extends StatefulWidget {
  const ThongTinNhom({super.key});

  @override
  State<ThongTinNhom> createState() => _ThongTinNhomState();
}

class _ThongTinNhomState extends State<ThongTinNhom> {
  late VideoPlayerController _bgController;
  late VideoPlayerController _cardBgController;
  late VideoPlayerController _introController;

  @override
  void initState() {
    super.initState();

    _bgController = VideoPlayerController.asset("assets/video/nenthongtin.mp4");
    _cardBgController = VideoPlayerController.asset(
      "assets/video/nenthongtin1.mp4",
    );
    _introController = VideoPlayerController.asset("assets/video/intro.mp4");

    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    await Future.wait([
      _bgController.initialize(),
      _cardBgController.initialize(),
      _introController.initialize(),
    ]);

    for (var controller in [
      _bgController,
      _cardBgController,
      _introController,
    ]) {
      controller
        ..setLooping(true)
        ..setVolume(0)
        ..play();
    }

    setState(() {});
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cardBgController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ===== BACKGROUND VIDEO TOÀN MÀN =====
          SizedBox.expand(
            child: _bgController.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _bgController.value.size.width,
                      height: _bgController.value.size.height,
                      child: VideoPlayer(_bgController),
                    ),
                  )
                : Container(color: Colors.black),
          ),

          /// Lớp tối nhẹ
          Container(color: Colors.black.withOpacity(0.4)),

          /// ===== NỘI DUNG =====
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      /// ===== VIDEO NỀN TRONG CARD =====
                      SizedBox(
                        width: double.infinity,
                        child: _cardBgController.value.isInitialized
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _cardBgController.value.size.width,
                                  height: _cardBgController.value.size.height,
                                  child: VideoPlayer(_cardBgController),
                                ),
                              )
                            : Container(color: Colors.black),
                      ),

                      /// Lớp mờ để đọc chữ rõ hơn
                      Container(
                        padding: const EdgeInsets.all(24),
                        color: Colors.black.withOpacity(0.55),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// ===== VIDEO INTRO =====
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: _introController.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _introController.value.aspectRatio,
                                      child: VideoPlayer(_introController),
                                    )
                                  : const SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: CircularProgressIndicator(),
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

                            /// ===== GIẢNG VIÊN (HIỂN THỊ TRƯỚC) =====
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

                            /// ===== SINH VIÊN =====
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
