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
  bool daPhatLanDau = false;

  int baiDangPhat = 0;
  CheDoPhat cheDo = CheDoPhat.thuTu;

  // ================= DANH SÁCH NHẠC =================

  List<Map<String, dynamic>> danhSachNhac = [
    {
      "ten": "Chờ Anh Về",
      "file": "CHỜ ANH VỀ.mp3",
      "poster": "assets/hinh_anh/nhac/choanhve.jpg",
    },
    {
      "ten": "Bình Yên",
      "file": "Bình Yên.mp3",
      "poster": "assets/hinh_anh/nhac/binhyen.jpg",
    },
    {
      "ten": "In Love",
      "file": "In Love.mp3",
      "poster": "assets/hinh_anh/nhac/inlove.jpg",
    },
    {
      "ten": "Mục Hạ Vô Nhân",
      "file": "Mục Hạ Vô Nhân.mp3",
      "poster": "assets/hinh_anh/nhac/muchavonhan.jpg",
    },
    {
      "ten": "Ex’s Hate Me (Part 2)",
      "file": "Ex’s Hate Me (Part 2).mp3",
      "poster": "assets/hinh_anh/nhac/exhateme.jpg",
    },
    {
      "ten": "Mùa Mưa Ấy",
      "file": "Mùa Mưa Ấy.mp3",
      "poster": "assets/hinh_anh/nhac/muamuaaya.jpg",
    },
    {
      "ten": "24H (Moving on version)",
      "file": "24H (Moving on version).mp3",
      "poster": "assets/hinh_anh/nhac/24h.jpg",
    },
    {
      "ten": "Em Iu",
      "file": "Em Iu.mp3",
      "poster": "assets/hinh_anh/nhac/emiu.jpg",
    },
    {
      "ten": "Exit Sign",
      "file": "Exit Sign.mp3",
      "poster": "assets/hinh_anh/nhac/exitsign.jpg",
    },
    {
      "ten": "2GOILAYS",
      "file": "2GOILAYS.mp3",
      "poster": "assets/hinh_anh/nhac/2goilays.jpg",
    },
    {
      "ten": "Ghé Qua",
      "file": "Ghé Qua.mp3",
      "poster": "assets/hinh_anh/nhac/ghequa.jpg",
    },
    {
      "ten": "Hai Thằng Bịp",
      "file": "Hai Thằng Bịp.mp3",
      "poster": "assets/hinh_anh/nhac/haithangbip.jpg",
    },
    {
      "ten": "Nếu Những Tiếc Nuối",
      "file": "Nếu Những Tiếc Nuối.mp3",
      "poster": "assets/hinh_anh/nhac/neunhungtiecnuoi.jpg",
    },
    {
      "ten": "Những Lời Hứa Bỏ Quên",
      "file": "Những Lời Hứa Bỏ Quên.mp3",
      "poster": "assets/hinh_anh/nhac/nhungloihuaboquen.jpg",
    },
    {
      "ten": "Tim Anh Ghen",
      "file": "Tim Anh Ghen.mp3",
      "poster": "assets/hinh_anh/nhac/timanhghen.jpg",
    },
  ];

  // ================= DANH SÁCH SÁCH =================

  List<Map<String, String>> danhSachSach = [
    {
      "ten": "Ca dao tục ngữ",
      "file": "assets/sach/Ca dao tục ngữ.txt",
      "poster": "assets/hinh_anh/sach/cadaotucngu.jpg",
    },
    {
      "ten": "Truyện Kiều",
      "file": "assets/sach/Truyện Kiều.txt",
      "poster": "assets/hinh_anh/sach/truyenkieu.jpg",
    },
    {
      "ten": "Hầu trời",
      "file": "assets/sach/Hầu trời.txt",
      "poster": "assets/hinh_anh/sach/Hầu trời.jpg",
    },
  ];

  // ================= TRÍCH DẪN =================

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
    if (index < 0 || index >= danhSachNhac.length) return;

    await _audioPlayer.stop();
    await _audioPlayer.play(
      AssetSource("am_thanh/${danhSachNhac[index]["file"]}"),
    );

    setState(() {
      baiDangPhat = index;
      dangPhatNhac = true;
      daPhatLanDau = true;
    });
  }

  Future<void> _pausePlay() async {
    if (!daPhatLanDau) {
      await _phatBai(baiDangPhat);
      return;
    }

    if (dangPhatNhac) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }

    setState(() => dangPhatNhac = !dangPhatNhac);
  }

  void _xuLyKhiHetBai() {
    switch (cheDo) {
      case CheDoPhat.lapMot:
        _phatBai(baiDangPhat);
        break;
      case CheDoPhat.ngauNhien:
        _phatBai(Random().nextInt(danhSachNhac.length));
        break;
      case CheDoPhat.lapTatCa:
        _phatBai((baiDangPhat + 1) % danhSachNhac.length);
        break;
      case CheDoPhat.thuTu:
        if (baiDangPhat < danhSachNhac.length - 1) {
          _phatBai(baiDangPhat + 1);
        } else {
          setState(() => dangPhatNhac = false);
        }
        break;
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

  String _tenCheDo() {
    switch (cheDo) {
      case CheDoPhat.ngauNhien:
        return "Ngẫu nhiên";
      case CheDoPhat.lapMot:
        return "Lặp 1 bài";
      case CheDoPhat.lapTatCa:
        return "Lặp tất cả";
      default:
        return "Theo thứ tự";
    }
  }

  // ================= MỞ SÁCH =================

  Future<void> _moSach(String filePath, String tenSach) async {
    String noiDung = await rootBundle.loadString(filePath);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(tenSach)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Text(noiDung, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ),
    );
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
            child: Container(color: Colors.black.withOpacity(0.55)),
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

                // PLAYER
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            danhSachNhac[baiDangPhat]["poster"],
                            height: 170,
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
                        Text(
                          _tenCheDo(),
                          style: const TextStyle(color: Colors.grey),
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

                // GRID NHẠC
                const Text(
                  "Danh sách nhạc",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 170,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: danhSachNhac.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      final dangChay = index == baiDangPhat && dangPhatNhac;

                      return GestureDetector(
                        onTap: () => _phatBai(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: dangChay
                                ? Border.all(color: Colors.green, width: 3)
                                : null,
                          ),
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
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // GRID SÁCH
                const Text(
                  "Sách thư giãn",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 180,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: danhSachSach.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _moSach(
                          danhSachSach[index]["file"]!,
                          danhSachSach[index]["ten"]!,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Image.asset(
                                danhSachSach[index]["poster"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Container(color: Colors.black.withOpacity(0.4)),
                              Center(
                                child: Text(
                                  danhSachSach[index]["ten"]!,
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

                const SizedBox(height: 30),

                // TRÍCH DẪN
                const Text(
                  "Trích dẫn truyền cảm hứng",
                  style: TextStyle(
                    fontSize: 20,
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(quote),
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
