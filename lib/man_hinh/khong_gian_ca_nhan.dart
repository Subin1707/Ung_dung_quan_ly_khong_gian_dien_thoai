import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../mo_hinh/ghi_chu.dart';

class KhongGianCaNhan extends StatefulWidget {
  const KhongGianCaNhan({super.key});

  @override
  State<KhongGianCaNhan> createState() => _KhongGianCaNhanState();
}

class _KhongGianCaNhanState extends State<KhongGianCaNhan> {
  final List<GhiChu> danhSach = [];
  final ImagePicker _picker = ImagePicker();

  String _taoId() => DateTime.now().millisecondsSinceEpoch.toString();

  void _themKyNiem() {
    TextEditingController controller = TextEditingController();
    List<String> selectedImages = [];
    List<String> selectedVideos = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              title: const Text("Thêm kỷ niệm"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Nội dung",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // CHỌN ẢNH
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Chọn nhiều ảnh"),
                      onPressed: () async {
                        final images = await _picker.pickMultiImage(
                          imageQuality: 80,
                          maxWidth: 1920,
                        );

                        if (!mounted) return;

                        if (images.isNotEmpty) {
                          setStateDialog(() {
                            selectedImages = images.map((e) => e.path).toList();
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // CHỌN VIDEO
                    ElevatedButton.icon(
                      icon: const Icon(Icons.video_library),
                      label: const Text("Chọn video"),
                      onPressed: () async {
                        final video = await _picker.pickVideo(
                          source: ImageSource.gallery,
                        );

                        if (!mounted) return;

                        if (video != null) {
                          setStateDialog(() {
                            selectedVideos.add(video.path);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // PREVIEW ẢNH
                    if (selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            final file = File(selectedImages[index]);

                            if (!file.existsSync()) {
                              return Container(
                                width: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              );
                            }

                            return GestureDetector(
                              onTap: () => _xemAnh(file),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    file,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    if (selectedVideos.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Icon(
                          Icons.movie,
                          size: 50,
                          color: Colors.deepPurple,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isEmpty) return;

                    setState(() {
                      danhSach.add(
                        GhiChu(
                          id: _taoId(),
                          noiDung: controller.text,
                          hinhAnhPaths: List.from(selectedImages),
                          videoPaths: List.from(selectedVideos),
                        ),
                      );
                    });

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

  void _xemAnh(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(
                file,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 100,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _xemVideo(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VideoScreen(path: path)),
    );
  }

  void _xoa(int index) {
    setState(() {
      danhSach.removeAt(index);
    });
  }

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
              itemBuilder: (context, index) {
                final ghiChu = danhSach[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ghiChu.noiDung,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ghiChu.hinhAnhPaths.length,
                              itemBuilder: (context, imgIndex) {
                                final file = File(
                                  ghiChu.hinhAnhPaths[imgIndex],
                                );

                                if (!file.existsSync()) {
                                  return const SizedBox();
                                }

                                return GestureDetector(
                                  onTap: () => _xemAnh(file),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        file,
                                        width: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
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
                                      size: 60,
                                      color: Colors.deepPurple,
                                    ),
                                    onPressed: () => _xemVideo(v),
                                  ),
                                )
                                .toList(),
                          ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _xoa(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: _themKyNiem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String path;
  const VideoScreen({super.key, required this.path});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.file(File(widget.path));

    controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            controller.value.isPlaying ? controller.pause() : controller.play();
          });
        },
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
