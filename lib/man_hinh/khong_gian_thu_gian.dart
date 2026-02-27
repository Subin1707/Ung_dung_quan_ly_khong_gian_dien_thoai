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
  String noiDungSach = "Đang tải sách...";

  int baiDangPhat = 0;
  CheDoPhat cheDo = CheDoPhat.thuTu;

  List<Map<String, dynamic>> danhSachNhac = [
    {"ten": "Chờ Anh Về", "file": "am_thanh/CHỜ ANH VỀ.mp3", "yeuThich": false},
    {
      "ten": "24H (Moving on version)",
      "file": "am_thanh/24H (Moving on version).mp3",
      "yeuThich": false,
    },
    {
      "ten": "Tim Anh Ghen",
      "file": "am_thanh/Tim Anh Ghen.mp3",
      "yeuThich": false,
    },
    {"ten": "2GOILAYS", "file": "am_thanh/2GOILAYS.mp3", "yeuThich": false},
    {"ten": "Bình Yên", "file": "am_thanh/Bình Yên.mp3", "yeuThich": false},
    {
      "ten": "Ex’s Hate Me (Part 2)",
      "file": "am_thanh/Ex’s Hate Me (Part 2).mp3",
      "yeuThich": false,
    },
    {"ten": "Em Iu", "file": "am_thanh/Em Iu.mp3", "yeuThich": false},
    {"ten": "Ghé Qua", "file": "am_thanh/Ghé Qua.mp3", "yeuThich": false},
    {"ten": "Exit Sign", "file": "am_thanh/Exit Sign.mp3", "yeuThich": false},
    {
      "ten": "Hai Thằng Bịp",
      "file": "am_thanh/Hai Thằng Bịp.mp3",
      "yeuThich": false,
    },
    {"ten": "In Love", "file": "am_thanh/In Love.mp3", "yeuThich": false},
    {"ten": "Mùa Mưa Ấy", "file": "am_thanh/Mùa Mưa Ấy.mp3", "yeuThich": false},
    {
      "ten": "Những Lời Hứa Bỏ Quên",
      "file": "am_thanh/Những Lời Hứa Bỏ Quên.mp3",
      "yeuThich": false,
    },
    {
      "ten": "Nếu Những Tiếc Nuối",
      "file": "am_thanh/Nếu Những Tiếc Nuối.mp3",
      "yeuThich": false,
    },
    {
      "ten": "Mục Hạ Vô Nhân",
      "file": "am_thanh/Mục Hạ Vô Nhân.mp3",
      "yeuThich": false,
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
    _taiSach();

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

  // ================= SÁCH =================

  Future<void> _taiSach() async {
    try {
      final data = await rootBundle.loadString(
        "assets/hinh_anh/Báo cáo đồ ân cơ sở.docx",
      );
      if (mounted) setState(() => noiDungSach = data);
    } catch (_) {
      if (mounted) setState(() => noiDungSach = "Không tìm thấy file sách.");
    }
  }

  // ================= PHÁT NHẠC =================

  Future<void> _phatBai(int index) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(danhSachNhac[index]["file"]));

    setState(() {
      baiDangPhat = index;
      dangPhatNhac = true;
    });
  }

  Future<void> _pausePlay() async {
    if (dangPhatNhac) {
      await _audioPlayer.pause();
      setState(() => dangPhatNhac = false);
    } else {
      await _audioPlayer.resume();
      setState(() => dangPhatNhac = true);
    }
  }

  // ================= LOGIC HẾT BÀI =================

  void _xuLyKhiHetBai() {
    if (cheDo == CheDoPhat.lapMot) {
      _phatBai(baiDangPhat);
    } else if (cheDo == CheDoPhat.ngauNhien) {
      _phatBai(Random().nextInt(danhSachNhac.length));
    } else if (cheDo == CheDoPhat.lapTatCa) {
      _phatBai((baiDangPhat + 1) % danhSachNhac.length);
    } else {
      if (baiDangPhat < danhSachNhac.length - 1) {
        _phatBai(baiDangPhat + 1);
      } else {
        setState(() => dangPhatNhac = false);
      }
    }
  }

  void _doiCheDo() {
    setState(() {
      cheDo = CheDoPhat.values[(cheDo.index + 1) % CheDoPhat.values.length];
    });
  }

  void _doiYeuThich(int index) {
    setState(() {
      danhSachNhac[index]["yeuThich"] =
          !(danhSachNhac[index]["yeuThich"] ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          danhSachNhac[index]["yeuThich"]
              ? "Đã thêm vào yêu thích ❤️"
              : "Đã bỏ khỏi yêu thích",
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.favorite),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NhacYeuThich(
                danhSach: danhSachNhac
                    .where((b) => b["yeuThich"] == true)
                    .toList(),
              ),
            ),
          );
        },
      ),
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
            child: Container(color: Colors.black.withOpacity(0.4)),
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          danhSachNhac[baiDangPhat]["ten"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                size: 45,
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
                              icon: Icon(
                                cheDo == CheDoPhat.ngauNhien
                                    ? Icons.shuffle
                                    : cheDo == CheDoPhat.lapMot
                                    ? Icons.repeat_one
                                    : Icons.repeat,
                              ),
                              onPressed: _doiCheDo,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // DANH SÁCH NHẠC
                ...List.generate(danhSachNhac.length, (index) {
                  bool dangPhat = index == baiDangPhat && dangPhatNhac;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        dangPhat ? Icons.graphic_eq : Icons.music_note,
                      ),
                      title: Text(danhSachNhac[index]["ten"]),
                      trailing: IconButton(
                        icon: Icon(
                          danhSachNhac[index]["yeuThich"]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () => _doiYeuThich(index),
                      ),
                      onTap: () => _phatBai(index),
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // SÁCH
                const Text(
                  "Sách yêu thích",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(noiDungSach),
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
                const SizedBox(height: 10),
                ...danhSachTrichDan.map(
                  (quote) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(quote),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MÀN HÌNH YÊU THÍCH =================

class NhacYeuThich extends StatelessWidget {
  final List<Map<String, dynamic>> danhSach;

  const NhacYeuThich({super.key, required this.danhSach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhạc yêu thích")),
      body: danhSach.isEmpty
          ? const Center(child: Text("Chưa có bài yêu thích"))
          : ListView.builder(
              itemCount: danhSach.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(danhSach[index]["ten"]),
                );
              },
            ),
    );
  }
}
