import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ThongTinNhom extends StatefulWidget {
  const ThongTinNhom({super.key});

  @override
  State<ThongTinNhom> createState() => _ThongTinNhomState();
}

class _ThongTinNhomState extends State<ThongTinNhom> {
  late VideoPlayerController _bgController;
  late VideoPlayerController _introController;

  @override
  void initState() {
    super.initState();

    // ===== VIDEO BACKGROUND =====
    _bgController = VideoPlayerController.asset("assets/video/nenthongtin.mp4")
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(0)
      ..play();

    // ===== VIDEO INTRO TRONG CARD =====
    _introController = VideoPlayerController.asset("assets/video/intro.mp4")
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(0)
      ..play();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ===== BACKGROUND VIDEO =====
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

          /// Lớp tối cho dễ đọc
          Container(color: Colors.black.withOpacity(0.4)),

          /// ===== NỘI DUNG =====
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Card(
                  color: Colors.white.withOpacity(0.92),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
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
                          ),
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

                        _thongTinDong(
                          "Môn học",
                          "Lập trình cho thiết bị di động",
                        ),
                        _thongTinDong(
                          "Tên đề tài",
                          "Quản lý & cá nhân hóa không gian điện thoại",
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.school, color: Colors.deepPurple),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Giảng viên hướng dẫn:\nTS. Nguyễn Xuân Quế",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
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
