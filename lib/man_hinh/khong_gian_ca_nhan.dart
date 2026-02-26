import 'package:flutter/material.dart';
import '../mo_hinh/ghi_chu.dart';

class KhongGianCaNhan extends StatefulWidget {
  const KhongGianCaNhan({super.key});

  @override
  State<KhongGianCaNhan> createState() => _KhongGianCaNhanState();
}

class _KhongGianCaNhanState extends State<KhongGianCaNhan> {
  final List<GhiChu> danhSach = [];

  void _themKyNiem() {
    TextEditingController controller = TextEditingController();
    String? selectedImage;
    String? selectedVideo;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Thêm kỷ niệm"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(labelText: "Nội dung"),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Chọn ảnh mẫu"),
                      onPressed: () {
                        setStateDialog(() {
                          selectedImage = "lib/assets/hinh_anh/anh1.jpg";
                          selectedVideo = null;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      icon: const Icon(Icons.video_library),
                      label: const Text("Chọn video mẫu"),
                      onPressed: () {
                        setStateDialog(() {
                          selectedVideo = "lib/assets/video/video1.mp4";
                          selectedImage = null;
                        });
                      },
                    ),

                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(selectedImage!, height: 100),
                      ),

                    if (selectedVideo != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Icon(Icons.movie, size: 60),
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
                          noiDung: controller.text,
                          hinhAnh: selectedImage,
                          video: selectedVideo,
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

  void _xoa(int index) {
    setState(() {
      danhSach.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Không gian cá nhân")),
      body: danhSach.isEmpty
          ? const Center(
              child: Text(
                "Chưa có kỷ niệm nào",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: danhSach.length,
              itemBuilder: (context, index) {
                final ghiChu = danhSach[index];

                return Card(
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

                        const SizedBox(height: 10),

                        if (ghiChu.hinhAnh != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              ghiChu.hinhAnh!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        if (ghiChu.video != null)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.movie,
                              size: 80,
                              color: Colors.blue,
                            ),
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
        onPressed: _themKyNiem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
