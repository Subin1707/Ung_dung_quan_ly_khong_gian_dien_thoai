import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../mo_hinh/ghi_chu.dart';
import '../database/database_helper.dart';
import 'package:khonggiandienthoai/ngon_ngu/ngon_ngu_quan_ly.dart';
import '../widgets/app_drawer.dart';

class VideoFullScreen extends StatefulWidget {
  final String path;
  const VideoFullScreen({super.key, required this.path});

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
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
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

class KhongGianCaNhan extends StatefulWidget {
  const KhongGianCaNhan({super.key});

  @override
  State<KhongGianCaNhan> createState() => _KhongGianCaNhanState();
}

class _KhongGianCaNhanState extends State<KhongGianCaNhan> {
  List<GhiChu> danhSach = [];
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _bgController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initBackgroundVideo();
  }

  Future<void> _initBackgroundVideo() async {
    _bgController = VideoPlayerController.asset(
      "assets/video/nenkhonggiacanhan.mp4",
    );
    await _bgController!.initialize();
    await _bgController!.setLooping(true);
    await _bgController!.setVolume(0);
    await _bgController!.play();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bgController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllGhiChu();
    if (mounted) setState(() => danhSach = data);
  }

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<bool> _xinQuyenMedia() async {
    if (!Platform.isAndroid) return true;

    final images = await Permission.photos.request();
    final videos = await Permission.videos.request();

    if (images.isGranted && videos.isGranted) return true;

    if (images.isPermanentlyDenied || videos.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  void _themKyNiem() {
    final lang = context.read<NgonNguQuanLy>();

    final tieuDeController = TextEditingController();
    final noiDungController = TextEditingController();

    List<String> selectedImages = [];
    List<String> selectedVideos = [];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            scrollable: true,
            title: Text(lang.text("add_memory")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tieuDeController,
                  decoration: InputDecoration(
                    labelText: lang.text("title"),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noiDungController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: lang.text("content"),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: Text(lang.text("choose_images")),
                  onPressed: () async {
                    if (!await _xinQuyenMedia()) return;
                    final images = await _picker.pickMultiImage(
                      imageQuality: 80,
                    );
                    if (images.isNotEmpty) {
                      setStateDialog(() {
                        selectedImages = images.map((e) => e.path).toList();
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.video_library),
                  label: Text(lang.text("choose_video")),
                  onPressed: () async {
                    if (!await _xinQuyenMedia()) return;
                    final video = await _picker.pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (video != null) {
                      setStateDialog(() {
                        selectedVideos.add(video.path);
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(lang.text("cancel")),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (tieuDeController.text.isEmpty ||
                      noiDungController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(lang.text("please_fill"))),
                    );
                    return;
                  }

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
                  if (mounted) Navigator.pop(context);
                },
                child: Text(lang.text("save")),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _xoa(String id) async {
    final lang = context.read<NgonNguQuanLy>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(lang.text("confirm_delete")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(lang.text("cancel")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(lang.text("delete")),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteGhiChu(id);
      await _loadData();
    }
  }

  void _moVideo(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VideoFullScreen(path: path)),
    );
  }

  void _moAnh(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: Center(child: Image.file(File(path))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<NgonNguQuanLy>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(lang.text("personal_space")),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _bgController != null && _bgController!.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _bgController!.value.size.width,
                      height: _bgController!.value.size.height,
                      child: VideoPlayer(_bgController!),
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
                      lang.text("no_memory"),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: danhSach.length,
                    itemBuilder: (_, index) {
                      final ghiChu = danhSach[index];

                      return Card(
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

                              if (ghiChu.hinhAnhPaths.isNotEmpty)
                                SizedBox(
                                  height: 110,
                                  child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ghiChu.hinhAnhPaths.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          mainAxisSpacing: 8,
                                        ),
                                    itemBuilder: (_, i) {
                                      final img = ghiChu.hinhAnhPaths[i];
                                      return GestureDetector(
                                        onTap: () => _moAnh(img),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.file(
                                            File(img),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              if (ghiChu.videoPaths.isNotEmpty)
                                Column(
                                  children: ghiChu.videoPaths
                                      .map(
                                        (v) => IconButton(
                                          icon: const Icon(
                                            Icons.play_circle,
                                            size: 50,
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
