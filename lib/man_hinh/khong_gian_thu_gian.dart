import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class KhongGianThuGian extends StatefulWidget {
  const KhongGianThuGian({super.key});

  @override
  State<KhongGianThuGian> createState() => _KhongGianThuGianState();
}

class _KhongGianThuGianState extends State<KhongGianThuGian> {
  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool dangPhatNhac = false;
  bool videoSanSang = false;
  String noiDungSach = "Đang tải sách...";

  final List<String> danhSachTrichDan = [
    "Hôm nay là một ngày tuyệt vời để bắt đầu.",
    "Kiên trì sẽ đưa bạn đến thành công.",
    "Đừng so sánh, hãy phát triển.",
    "Tập trung vào mục tiêu của bạn.",
  ];

  @override
  void initState() {
    super.initState();
    _khoiTaoVideo();
    _taiSach();
  }

  /// ================= VIDEO =================
  void _khoiTaoVideo() async {
    try {
      _videoController = VideoPlayerController.asset("assets/video/relax.mp4");

      await _videoController.initialize();
      await _videoController.setLooping(true);
      await _videoController.setVolume(1.0);
      await _videoController.play();

      setState(() {
        videoSanSang = true;
      });
    } catch (e) {
      print("Lỗi video: $e");
    }
  }

  /// ================= SÁCH =================
  void _taiSach() async {
    try {
      final data = await rootBundle.loadString("assets/hinh_anh/sach.txt");
      setState(() {
        noiDungSach = data;
      });
    } catch (e) {
      setState(() {
        noiDungSach = "Không tìm thấy file sách.\n\nHãy kiểm tra lại assets.";
      });
      print("Lỗi đọc sách: $e");
    }
  }

  /// ================= NHẠC =================
  void _phatDungNhac() async {
    try {
      if (dangPhatNhac) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(AssetSource("am_thanh/nhac.mp3"));
      }

      setState(() {
        dangPhatNhac = !dangPhatNhac;
      });
    } catch (e) {
      print("Lỗi phát nhạc: $e");
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ===== VIDEO NỀN =====
          videoSanSang
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                )
              : Container(color: Colors.black),

          /// ===== LỚP PHỦ MỜ =====
          Container(color: Colors.black.withOpacity(0.4)),

          /// ===== NỘI DUNG =====
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),

                const Text(
                  "Không gian thư giãn",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                /// ===== NÚT NGHE NHẠC =====
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  icon: Icon(dangPhatNhac ? Icons.pause : Icons.music_note),
                  label: Text(
                    dangPhatNhac ? "Tạm dừng nhạc" : "Nghe nhạc yêu thích",
                  ),
                  onPressed: _phatDungNhac,
                ),

                const SizedBox(height: 25),

                /// ===== TRÍCH DẪN =====
                const Text(
                  "Trích dẫn truyền cảm hứng",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                ...danhSachTrichDan.map(
                  (quote) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(quote, style: const TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 25),

                /// ===== ĐỌC SÁCH =====
                const Text(
                  "Sách yêu thích",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    noiDungSach,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
