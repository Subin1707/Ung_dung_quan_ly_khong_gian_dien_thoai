import 'package:flutter/material.dart';
import '../mo_hinh/ghi_chu.dart';

class KhongGianCaNhan extends StatefulWidget {
  const KhongGianCaNhan({super.key});

  @override
  State<KhongGianCaNhan> createState() => _KhongGianCaNhanState();
}

class _KhongGianCaNhanState extends State<KhongGianCaNhan> {
  final List<GhiChu> danhSachGhiChu = [];

  void _themGhiChu() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm ghi chú"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Nhập nội dung ghi chú",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    danhSachGhiChu.add(GhiChu(noiDung: controller.text));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  void _xoaGhiChu(int index) {
    setState(() {
      danhSachGhiChu.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Không gian cá nhân"),
        centerTitle: true,
      ),

      body: danhSachGhiChu.isEmpty
          ? const Center(
              child: Text(
                "Chưa có ghi chú nào",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: danhSachGhiChu.length,
              itemBuilder: (context, index) {
                final ghiChu = danhSachGhiChu[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.note, size: 28),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            ghiChu.noiDung,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _xoaGhiChu(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _themGhiChu,
        child: const Icon(Icons.add),
      ),
    );
  }
}
