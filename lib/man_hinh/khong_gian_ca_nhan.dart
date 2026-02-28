import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

import '../mo_hinh/ghi_chu.dart';
import '../database/database_helper.dart';
import '../utils/app_text.dart';

class KhongGianCaNhan extends StatefulWidget {
  const KhongGianCaNhan({super.key});

  @override
  State<KhongGianCaNhan> createState() => _KhongGianCaNhanState();
}

class _KhongGianCaNhanState extends State<KhongGianCaNhan> {
  List<GhiChu> danhSach = [];
  final ImagePicker _picker = ImagePicker();

  late VideoPlayerController _bgController;

  @override
  void initState() {
    super.initState();
    _loadData();

    _bgController =
        VideoPlayerController.asset("assets/video/nenkhonggiacanhan.mp4")
          ..setLooping(true)
          ..setVolume(0)
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
              _bgController.play();
            }
          });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllGhiChu();
    setState(() => danhSach = data);
  }

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<bool> _xinQuyenMedia() async {
    if (!Platform.isAndroid) return true;

    final images = await Permission.photos.request();
    final videos = await Permission.videos.request();

    if (images.isPermanentlyDenied || videos.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return images.isGranted && videos.isGranted;
  }

  // ================= THÊM =================
  void _themKyNiem() {
    TextEditingController tieuDeController = TextEditingController();
    TextEditingController noiDungController = TextEditingController();

    List<String> selectedImages = [];
    List<String> selectedVideos = [];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              scrollable: true,
              title: Text(AppText.t(context, "Thêm kỷ niệm", "Add Memory")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tieuDeController,
                    decoration: InputDecoration(
                      labelText: AppText.t(context, "Tiêu đề", "Title"),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noiDungController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: AppText.t(context, "Nội dung", "Content"),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: Text(AppText.t(context, "Chọn ảnh", "Pick Images")),
                    onPressed: () async {
                      if (!await _xinQuyenMedia()) return;
                      final images = await _picker.pickMultiImage(
                        imageQuality: 80,
                      );
                      if (images.isEmpty) return;

                      setStateDialog(() {
                        selectedImages = images.map((e) => e.path).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.video_library),
                    label: Text(AppText.t(context, "Chọn video", "Pick Video")),
                    onPressed: () async {
                      if (!await _xinQuyenMedia()) return;
                      final video = await _picker.pickVideo(
                        source: ImageSource.gallery,
                      );
                      if (video == null) return;

                      setStateDialog(() {
                        selectedVideos.add(video.path);
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppText.t(context, "Hủy", "Cancel")),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (tieuDeController.text.isEmpty ||
                        noiDungController.text.isEmpty)
                      return;

                    final now = DateTime.now();

                    final ghiChu = GhiChu(
                      id: _taoId(),
                      tieuDe: tieuDeController.text,
                      noiDung: noiDungController.text,
                      hinhAnhPaths: selectedImages,
                      videoPaths: selectedVideos,
                      thoiGianTao: now,
                      thoiGianCapNhat: now,
                    );

                    await DatabaseHelper.instance.insertGhiChu(ghiChu);
                    await _loadData();

                    Navigator.pop(context);
                  },
                  child: Text(AppText.t(context, "Lưu", "Save")),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================= XOÁ =================
  Future<void> _xoa(String id) async {
    await DatabaseHelper.instance.deleteGhiChu(id);
    await _loadData();
  }

  // ================= MỞ VIDEO =================
  void _moVideo(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _VideoFullScreen(path: path)),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(AppText.t(context, "Không gian cá nhân", "Personal Space")),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
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
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: danhSach.isEmpty
                ? Center(
                    child: Text(
                      AppText.t(
                        context,
                        "Chưa có kỷ niệm nào",
                        "No memories yet",
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: danhSach.length,
                    itemBuilder: (_, index) {
                      final ghiChu = danhSach[index];

                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ghiChu.tieuDe,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(ghiChu.noiDung),
                              const SizedBox(height: 6),
                              Text(
                                ghiChu.thoiGianFormatted,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (ghiChu.coAnh)
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ghiChu.hinhAnhPaths.length,
                                    itemBuilder: (_, i) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Image.file(
                                          File(ghiChu.hinhAnhPaths[i]),
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              if (ghiChu.coVideo)
                                Column(
                                  children: ghiChu.videoPaths
                                      .map(
                                        (v) => IconButton(
                                          icon: const Icon(
                                            Icons.play_circle,
                                            size: 50,
                                            color: Colors.deepPurple,
                                          ),
                                          onPressed: () => _moVideo(v),
                                        ),
                                      )
                                      .toList(),
                                ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _xoa(ghiChu.id),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _themKyNiem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ================= VIDEO FULL SCREEN =================

class _VideoFullScreen extends StatefulWidget {
  final String path;

  const _VideoFullScreen({required this.path});

  @override
  State<_VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<_VideoFullScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
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
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
