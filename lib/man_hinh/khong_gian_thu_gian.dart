import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class KhongGianThuGian extends StatefulWidget {
  const KhongGianThuGian({super.key});

  @override
  State<KhongGianThuGian> createState() => _KhongGianThuGianState();
}

enum CheDoPhat { thuTu, ngauNhien, lapMot, lapTatCa }

class _KhongGianThuGianState extends State<KhongGianThuGian> {
  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool videoSanSang = false;
  bool dangPhatNhac = false;

  int baiDangPhat = 0;
  CheDoPhat cheDo = CheDoPhat.thuTu;

  // ================= DANH SÁCH NHẠC =================

  List<Map<String, dynamic>> danhSachNhac = [
    {
      "ten": "Chờ Anh Về",
      "file": "CHỜ ANH VỀ.mp3",
      "poster": "assets/hinh_anh/nhac/cho_anh_ve.jpg",
      "yeuThich": false,
    },
    {
      "ten": "Bình Yên",
      "file": "Bình Yên.mp3",
      "poster": "assets/hinh_anh/nhac/binh_yen.jpg",
      "yeuThich": false,
    },
    {
      "ten": "In Love",
      "file": "In Love.mp3",
      "poster": "assets/hinh_anh/nhac/in_love.jpg",
      "yeuThich": false,
    },
  ];

  // ================= DANH SÁCH SÁCH =================

  List<Map<String, String>> danhSachSach = [
    {
      "ten": "Chuyển đổi số",
      "file": "assets/sach/book1.txt",
      "poster": "assets/hinh_anh/sach/book1.jpg",
    },
    {
      "ten": "Sức mạnh tư duy",
      "file": "assets/sach/book2.txt",
      "poster": "assets/hinh_anh/sach/book2.jpg",
    },
  ];

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

    _audioPlayer.onPlayerComplete.listen((event) {
      _xuLyKhiHetBai();
    });
  }

  // ================= VIDEO =================

  Future<void> _khoiTaoVideo() async {
    _videoController = VideoPlayerController.asset("assets/video/videonen.mp4");

    await _videoController.initialize();
    await _videoController.setLooping(true);
    await _videoController.play();

    if (mounted) setState(() => videoSanSang = true);
  }

  // ================= PHÁT NHẠC =================

  Future<void> _phatBai(int index) async {
    await _audioPlayer.stop();

    await _audioPlayer.play(
      AssetSource("am_thanh/${danhSachNhac[index]["file"]}"),
    );

    setState(() {
      baiDangPhat = index;
      dangPhatNhac = true;
    });
  }

  Future<void> _pausePlay() async {
    if (dangPhatNhac) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() => dangPhatNhac = !dangPhatNhac);
  }

  void _xuLyKhiHetBai() {
    if (cheDo == CheDoPhat.lapMot) {
      _phatBai(baiDangPhat);
      return;
    }

    if (cheDo == CheDoPhat.ngauNhien) {
      _phatBai(Random().nextInt(danhSachNhac.length));
      return;
    }

    if (cheDo == CheDoPhat.lapTatCa) {
      _phatBai((baiDangPhat + 1) % danhSachNhac.length);
      return;
    }

    if (baiDangPhat < danhSachNhac.length - 1) {
      _phatBai(baiDangPhat + 1);
    } else {
      setState(() => dangPhatNhac = false);
    }
  }

  void _doiCheDo() {
    setState(() {
      cheDo = CheDoPhat.values[(cheDo.index + 1) % CheDoPhat.values.length];
    });
  }

  IconData _iconCheDo() {
    switch (cheDo) {
      case CheDoPhat.ngauNhien:
        return Icons.shuffle;
      case CheDoPhat.lapMot:
        return Icons.repeat_one;
      case CheDoPhat.lapTatCa:
        return Icons.repeat;
      default:
        return Icons.playlist_play;
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (videoSanSang)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          else
            Container(color: Colors.black),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Không gian thư giãn",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // ================= PLAYER =================
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            danhSachNhac[baiDangPhat]["poster"],
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          danhSachNhac[baiDangPhat]["ten"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              onPressed: () {
                                _phatBai(
                                  (baiDangPhat - 1 + danhSachNhac.length) %
                                      danhSachNhac.length,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                dangPhatNhac
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                size: 50,
                              ),
                              onPressed: _pausePlay,
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next),
                              onPressed: () {
                                _phatBai(
                                  (baiDangPhat + 1) % danhSachNhac.length,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(_iconCheDo()),
                              onPressed: _doiCheDo,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Danh sách nhạc",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 160,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: danhSachNhac.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _phatBai(index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Image.asset(
                                danhSachNhac[index]["poster"],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Container(color: Colors.black.withOpacity(0.4)),
                              Center(
                                child: Text(
                                  danhSachNhac[index]["ten"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
