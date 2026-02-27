import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

import '../mo_hinh/ghi_chu.dart';
import '../database/database_helper.dart';

class KhongGianCaNhan extends StatefulWidget {
  const KhongGianCaNhan({super.key});

  @override
  State<KhongGianCaNhan> createState() => _KhongGianCaNhanState();
}

class _KhongGianCaNhanState extends State<KhongGianCaNhan> {
  List<GhiChu> danhSach = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ================= LOAD DATA =================
  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllGhiChu();
    setState(() {
      danhSach = data;
    });
  }

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  // ================= PERMISSION =================
  Future<bool> _xinQuyenMedia() async {
    if (!Platform.isAndroid) return true;

    PermissionStatus images = await Permission.photos.request();
    PermissionStatus videos = await Permission.videos.request();

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Thêm kỷ niệm"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tieuDeController,
                    decoration: const InputDecoration(
                      labelText: "Tiêu đề",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noiDungController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Nội dung",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Chọn ảnh"),
                    onPressed: () async {
                      bool duocPhep = await _xinQuyenMedia();
                      if (!duocPhep) return;

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
                    label: const Text("Chọn video"),
                    onPressed: () async {
                      bool duocPhep = await _xinQuyenMedia();
                      if (!duocPhep) return;

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
                  child: const Text("Hủy"),
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
                  child: const Text("Lưu"),
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Không gian cá nhân"),
        centerTitle: true,
      ),
      body: danhSach.isEmpty
          ? const Center(child: Text("Chưa có kỷ niệm nào"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: danhSach.length,
              itemBuilder: (_, index) {
                final ghiChu = danhSach[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
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
                                final file = File(ghiChu.hinhAnhPaths[i]);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Image.file(file, width: 120),
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
                                    onPressed: () {},
                                  ),
                                )
                                .toList(),
                          ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _xoa(ghiChu.id),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _themKyNiem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
